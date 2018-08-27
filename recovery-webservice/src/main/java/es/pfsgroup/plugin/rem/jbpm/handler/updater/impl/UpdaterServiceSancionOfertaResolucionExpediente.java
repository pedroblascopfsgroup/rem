package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.*;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateOfertaApi;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Component
public class UpdaterServiceSancionOfertaResolucionExpediente implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private ActivoAdapter activoAdapter;

    @Autowired
    private UvemManagerApi uvemManagerApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private UpdaterStateOfertaApi updaterStateOfertaApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResolucionExpediente.class);

    private static final String COMBO_PROCEDE = "comboProcede";
    private static final String MOTIVO_ANULACION = "motivoAnulacion";
    private static final String MOTIVO_ANULACION_RESERVA = "comboMotivoAnulacionReserva";
    private static final String CODIGO_T013_RESOLUCION_EXPEDIENTE = "T013_ResolucionExpediente";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			String estadoOriginal = null;
			if (!Checks.esNulo(expediente.getEstado())){
				estadoOriginal = expediente.getEstado().getCodigo();
			}
			String valorComboProcede= null;
			String valorComboMotivoAnularReserva= null;
			
			Activo activo = expediente.getOferta().getActivoPrincipal();
			boolean checkFormalizar = false;
			if(!Checks.esNulo(activo)){
				PerimetroActivo pac = genericDao.get(PerimetroActivo.class, genericDao.createFilter(FilterType.EQUALS, "activo", activo));
				checkFormalizar = pac.getAplicaFormalizar() != 0;
			}

			if(!Checks.esNulo(expediente)) {

				boolean tieneReserva = false;
				if(valores != null && !valores.isEmpty()){
					tieneReserva = ofertaApi.checkReserva(valores.get(0).getTareaExterna()) && !Checks.esNulo(expediente.getReserva()) && 
							(DDEstadosReserva.CODIGO_FIRMADA.equals(expediente.getReserva().getEstadoReserva().getCodigo()) ||
									DDEstadosReserva.CODIGO_RESUELTA_POSIBLE_REINTEGRO.equals(expediente.getReserva().getEstadoReserva().getCodigo()) || 
									DDEstadosReserva.CODIGO_PENDIENTE_DEVOLUCION.equals(expediente.getReserva().getEstadoReserva().getCodigo()));
				}

				for(TareaExternaValor valor :  valores) {
					
					if(!DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())
							&& COMBO_PROCEDE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
							valorComboProcede= valor.getValor();
							
							updaterStateOfertaApi.updaterStateDevolucionReserva(valorComboProcede, tramite, ofertaAceptada, expediente);
					}
					
					if(MOTIVO_ANULACION_RESERVA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						valorComboMotivoAnularReserva= valor.getValor();
					}

					if(MOTIVO_ANULACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						// Se incluye un motivo de anulacion del expediente, si se indico en la tarea
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
						DDMotivoAnulacionExpediente motivoAnulacion = genericDao.get(DDMotivoAnulacionExpediente.class, filtro);
						expediente.setMotivoAnulacion(motivoAnulacion);

						if(!tieneReserva && DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo()) &&
								!DDEstadosExpedienteComercial.EN_TRAMITACION.equals(estadoOriginal) && checkFormalizar) {
							// Notificar del rechazo de la oferta a Bankia.
							try {
								uvemManagerApi.anularOferta(ofertaAceptada.getNumOferta().toString(), uvemManagerApi.obtenerMotivoAnulacionOfertaPorCodigoMotivoAnulacion(valor.getValor()));
							} catch (Exception e) {
								logger.error("Error al invocar el servicio de anular oferta de Uvem.", e);
								throw new UserException(e.getMessage());
							}
						}

						// TODO: Publicaciones - Implementar en el SP de publicación la siguiente condición:
						// Si la oferta es express, el activo se encuentra en estado publicado oculto y su motivo del estado es "Oferta Express Cajamar".
						activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());

						//Tipo rechazo y motivo rechazo ofertas cajamar
						DDTipoRechazoOferta tipoRechazo = (DDTipoRechazoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoRechazoOferta.class, DDTipoRechazoOferta.CODIGO_ANULADA);

						DDMotivoRechazoOferta motivoRechazo = (DDMotivoRechazoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRechazoOferta.class, valor.getValor());
						motivoRechazo.setTipoRechazo(tipoRechazo);
						ofertaAceptada.setMotivoRechazo(motivoRechazo);
						genericDao.save(Oferta.class, ofertaAceptada);
						genericDao.save(ExpedienteComercial.class, expediente);
					}
				}
				
				if(DDDevolucionReserva.CODIGO_NO.equals(valorComboProcede)){
					if(tieneReserva && DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())){
						try {
							uvemManagerApi.notificarDevolucionReserva(ofertaAceptada.getNumOferta().toString(), uvemManagerApi.obtenerMotivoAnulacionPorCodigoMotivoAnulacionReserva(valorComboMotivoAnularReserva),
									UvemManagerApi.INDICADOR_DEVOLUCION_RESERVA.NO_DEVOLUCION_RESERVA, UvemManagerApi.CODIGO_SERVICIO_MODIFICACION.PROPUESTA_ANULACION_RESERVA_FIRMADA);
						} catch (Exception e) {
							logger.error("Error al invocar el servicio de devolucion de reserva de Uvem.", e);
							throw new UserException(e.getMessage());
						}
					}
				}
				else{
					if(tieneReserva && DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())){
						try {
							uvemManagerApi.notificarDevolucionReserva(ofertaAceptada.getNumOferta().toString(), uvemManagerApi.obtenerMotivoAnulacionPorCodigoMotivoAnulacionReserva(valorComboMotivoAnularReserva),
									UvemManagerApi.INDICADOR_DEVOLUCION_RESERVA.DEVOLUCION_RESERVA, UvemManagerApi.CODIGO_SERVICIO_MODIFICACION.PROPUESTA_ANULACION_RESERVA_FIRMADA);
						} catch (Exception e) {
							logger.error("Error al invocar el servicio de devolucion de reserva de Uvem.", e);
							throw new UserException(e.getMessage());
						}
					}

				}

				if(valores != null && !valores.isEmpty() && !tieneReserva) {
					// Anula el expediente si NO tiene reserva.
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					expediente.setFechaVenta(null);
					expediente.setEstado(estado);
					expediente.setFechaAnulacion(new Date());

					//Finaliza el trámite
					Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", UpdaterStateOfertaApi.CODIGO_TRAMITE_FINALIZADO);
					tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
					genericDao.save(ActivoTramite.class, tramite);

					//Rechaza la oferta y descongela el resto
					ofertaApi.rechazarOferta(ofertaAceptada);
					try {
						ofertaApi.descongelarOfertas(expediente);
					} catch (Exception e) {
						logger.error("Error descongelando ofertas.", e);
					}

					genericDao.save(ExpedienteComercial.class, expediente);
				}
			}

			try {
				//Actualizar el estado comercial de los activos de la oferta
				ofertaApi.updateStateDispComercialActivosByOferta(ofertaAceptada);
				//Actualizar el estado de la publicación de los activos de la oferta (desocultar activos)
				ofertaApi.desocultarActivoOferta(ofertaAceptada);
			} catch (Exception e) {
				logger.error("Error al ocultar activos de la oferta.", e);
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RESOLUCION_EXPEDIENTE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
}
