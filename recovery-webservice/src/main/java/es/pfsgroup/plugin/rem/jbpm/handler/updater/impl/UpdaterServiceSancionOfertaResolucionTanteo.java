package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.adapter.NotificacionAdapter;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.gestor.GestorExpedienteComercialManager;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;
import es.pfsgroup.plugin.rem.oferta.NotificationOfertaManager;

@Component
public class UpdaterServiceSancionOfertaResolucionTanteo implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private UvemManagerApi uvemManagerApi;

    @Autowired
    private NotificacionAdapter notificacionAdapter;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired 
    private GestorExpedienteComercialManager gestorExpedienteComercialManager;
    
    @Autowired
    private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private NotificationOfertaManager notificationOfertaManager;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResolucionTanteo.class);

    private static final String COMBO_EJERCE = "comboEjerce";
    private static final String CAMPO_ADMINISTRACION = "administracion";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
    private static final String CODIGO_T013_RESOLUCION_TANTEO = "T013_ResolucionTanteo";
   	private static final Integer RESERVA_SI = 1;

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());

		String valorCampoEjerce= null;
		String valorCampoAdministracion="";
		DDResultadoTanteo resultadoTanteo = new DDResultadoTanteo();

		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			Activo activo = ofertaAceptada.getActivoPrincipal();

			if(!Checks.esNulo(expediente)) {

				for(TareaExternaValor valor :  valores) {

					if(COMBO_EJERCE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						Filter filtro;
						if(DDSiNo.SI.equals(valor.getValor())){
							//Anula el expediente
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);

							//Finaliza el trámite
							Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
							tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
							genericDao.save(ActivoTramite.class, tramite);

							//Rechaza la oferta y descongela el resto
							ofertaApi.rechazarOferta(ofertaAceptada);
							try {
								ofertaApi.descongelarOfertas(expediente);
							} catch (Exception e) {
								logger.error("Error descongelando ofertas.", e);
							}
							
							/*if(!ofertaApi.checkReserva(ofertaAceptada) && DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())) {
								// Notificar del rechazo de la oferta a Bankia.
								try {
									uvemManagerApi.anularOferta(ofertaAceptada.getNumOferta().toString(), UvemManagerApi.MOTIVO_ANULACION_OFERTA.COMPRADOR_NO_INTERESADO_OPERACION);
								} catch (Exception e) {
									logger.error("Error al invocar el servicio de anular oferta de Uvem.", e);
									throw new UserException(e.getMessage());
								}
							}*/
							
							Filter filtroTanteo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoTanteo.CODIGO_EJERCIDO);
							resultadoTanteo = genericDao.get(DDResultadoTanteo.class, filtroTanteo);
							ofertaAceptada.setResultadoTanteo(resultadoTanteo);
						} else {
							Reserva reserva = expediente.getReserva();
							if (!Checks.esNulo(reserva)) {
								if (DDEstadosReserva.CODIGO_FIRMADA.equals(reserva.getEstadoReserva().getCodigo())) {
									filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
											DDEstadosExpedienteComercial.RESERVADO);
								} else {
									filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
											DDEstadosExpedienteComercial.APROBADO);
								}
							} else {
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
										DDEstadosExpedienteComercial.APROBADO);
							}

							Filter filtroTanteo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoTanteo.CODIGO_RENUNCIADO);
							resultadoTanteo = genericDao.get(DDResultadoTanteo.class, filtroTanteo);
							ofertaAceptada.setResultadoTanteo(resultadoTanteo);
						}
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estado);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);
						
						if(DDEstadosExpedienteComercial.ANULADO.equals(estado.getCodigo())){
							expediente.setFechaVenta(null);
						}else if(DDEstadosExpedienteComercial.APROBADO.equals(estado.getCodigo())) {
							if(expediente.getCondicionante().getSolicitaReserva()!=null && RESERVA_SI.equals(expediente.getCondicionante().getSolicitaReserva())) {													
								EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
										.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GBOAR");

								if(gestorExpedienteComercialManager.getGestorByExpedienteComercialYTipo(expediente, "GBOAR") == null) {
									GestorEntidadDto ge = new GestorEntidadDto();
									ge.setIdEntidad(expediente.getId());
									ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
									ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gruboarding")).getId());								
									ge.setIdTipoGestor(tipoGestorComercial.getId());
									gestorExpedienteComercialManager.insertarGestorAdicionalExpedienteComercial(ge);																	
								}
							}
							
							expedienteComercialApi.calculoFormalizacionCajamar(ofertaAceptada);
							
							if(ofertaAceptada.getCheckForzadoCajamar() != null && ofertaAceptada.getCheckForzadoCajamar()) {
								GestorEntidadDto ge = new GestorEntidadDto();
								EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
										.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GIAFORM");
								
								ge.setIdEntidad(expediente.getId());
								ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
								ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gestformcajamar")).getId());								
								ge.setIdTipoGestor(tipoGestorComercial.getId());
								gestorExpedienteComercialManager.insertarGestorAdicionalExpedienteComercial(ge);
							}
							
						}
						valorCampoEjerce = resultadoTanteo.getDescripcion();
					}

					if(CAMPO_ADMINISTRACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						valorCampoAdministracion = valor.getValor();
					}					
				}

				// HREOS-2244 - Aviso gestor formalización fin tarea
				if(!Checks.esNulo(valorCampoEjerce)) {

					Notificacion notificacion = new Notificacion();	

					String descripcionNotificacion = "Se ha finalizado el trámite de tanteo con la administración #administracion para el expediente #numexpediente con el resultado de #resolucion.";
					Usuario destinatario = gestorExpedienteComercialManager.getGestorByExpedienteComercialYTipo(expediente, "GFORM");

					// Si hay gestor de formalización creamos el aviso.
					if(!Checks.esNulo(destinatario)) {		
						descripcionNotificacion = descripcionNotificacion.replace("#administracion", valorCampoAdministracion)
								.replace("#numexpediente", expediente.getNumExpediente().toString())
								.replace("#resolucion", valorCampoEjerce.toLowerCase());											

						notificacion.setIdActivo(ofertaAceptada.getActivoPrincipal().getId());
						notificacion.setDestinatario(destinatario.getId());
						notificacion.setDescripcion(descripcionNotificacion);
						notificacion.setTitulo("Finalización trámite de tanteo");

						try {
							notificacionAdapter.saveNotificacion(notificacion);
						} catch (ParseException e) {
							logger.error(e.getMessage());
						}
					}
				}
				
				if (!Checks.esNulo(ofertaAceptada.getVentaSobrePlano()) && ofertaAceptada.getVentaSobrePlano() 
						&& (DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo()) 
						|| DDEstadosExpedienteComercial.RESERVADO_PTE_PRO_MANZANA.equals(expediente.getEstado().getCodigo())))
					notificationOfertaManager.notificationReservaVentaSobrePlano(ofertaAceptada);
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RESOLUCION_TANTEO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
