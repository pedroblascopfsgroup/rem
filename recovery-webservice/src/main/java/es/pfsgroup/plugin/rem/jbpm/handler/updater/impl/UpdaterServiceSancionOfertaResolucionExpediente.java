package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDDevolucionReserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;

@Component
public class UpdaterServiceSancionOfertaResolucionExpediente implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private UvemManagerApi uvemManagerApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private UtilDiccionarioApi utilDiccionarioApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResolucionExpediente.class);

    private static final String COMBO_PROCEDE = "comboProcede";
    private static final String MOTIVO_ANULACION = "motivoAnulacion";
    private static final String MOTIVO_ANULACION_RESERVA = "comboMotivoAnulacionReserva";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
    private static final String CODIGO_T013_RESOLUCION_EXPEDIENTE = "T013_ResolucionExpediente";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			String valorComboProcede= null;
			String valorComboMotivoAnularReserva= null;

			if(!Checks.esNulo(expediente)) {

				Boolean tieneReserva = ofertaApi.checkReserva(valores.get(0).getTareaExterna()) && !Checks.esNulo(expediente.getReserva()) && 
						(DDEstadosReserva.CODIGO_FIRMADA.equals(expediente.getReserva().getEstadoReserva().getCodigo()) ||
								DDEstadosReserva.CODIGO_RESUELTA_POSIBLE_REINTEGRO.equals(expediente.getReserva().getEstadoReserva().getCodigo()) || 
								DDEstadosReserva.CODIGO_PENDIENTE_DEVOLUCION.equals(expediente.getReserva().getEstadoReserva().getCodigo()));

				for(TareaExternaValor valor :  valores) {

					if(COMBO_PROCEDE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						valorComboProcede= valor.getValor();
						Filter filtro;

						if(DDDevolucionReserva.CODIGO_NO.equals(valor.getValor())) {

							//Anula el expediente
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);

							expediente.setFechaAnulacion(new Date());

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
							Filter filtroTanteo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoTanteo.CODIGO_EJERCIDO);
							ofertaAceptada.setResultadoTanteo(genericDao.get(DDResultadoTanteo.class, filtroTanteo));

							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estado);
							genericDao.save(ExpedienteComercial.class, expediente);

							Reserva reserva = expediente.getReserva();
							if(!Checks.esNulo(reserva)){
								reserva.setIndicadorDevolucionReserva(0);
								Filter filtroEstadoReserva = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosReserva.CODIGO_RESUELTA_POSIBLE_REINTEGRO);
								DDEstadosReserva estadoReserva = genericDao.get(DDEstadosReserva.class, filtroEstadoReserva);
								reserva.setEstadoReserva(estadoReserva);
								reserva.setDevolucionReserva(this.getDevolucionReserva(valor.getValor()));
								
								genericDao.save(Reserva.class, reserva);
							}
						} else {
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.EN_DEVOLUCION);
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estado);
							genericDao.save(ExpedienteComercial.class, expediente);
							
							Reserva reserva = expediente.getReserva();
							if(!Checks.esNulo(reserva)){
								reserva.setIndicadorDevolucionReserva(1);
								Filter filtroEstadoReserva = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosReserva.CODIGO_PENDIENTE_DEVOLUCION);
								DDEstadosReserva estadoReserva = genericDao.get(DDEstadosReserva.class, filtroEstadoReserva);
								reserva.setEstadoReserva(estadoReserva);
								reserva.setDevolucionReserva(this.getDevolucionReserva(valor.getValor()));

								genericDao.save(Reserva.class, reserva);
							}
						}
					}
					
					if(MOTIVO_ANULACION_RESERVA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						valorComboMotivoAnularReserva= valor.getValor();
					}

					if(MOTIVO_ANULACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						// Se incluye un motivo de anulacion del expediente, si se indico en la tarea
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
						DDMotivoAnulacionExpediente motivoAnulacion = genericDao.get(DDMotivoAnulacionExpediente.class, filtro);
						expediente.setMotivoAnulacion(motivoAnulacion);

						if(!tieneReserva && DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())) {
							// Notificar del rechazo de la oferta a Bankia.
							try {
								uvemManagerApi.anularOferta(ofertaAceptada.getNumOferta().toString(), uvemManagerApi.obtenerMotivoAnulacionOfertaPorCodigoMotivoAnulacion(valor.getValor()));
							} catch (Exception e) {
								logger.error("Error al invocar el servicio de anular oferta de Uvem.", e);
								throw new UserException(e.getMessage());
							}
						}

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
					expediente.setEstado(estado);
					expediente.setFechaAnulacion(new Date());

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

	private DDDevolucionReserva getDevolucionReserva(String codigo) {
		Filter filtroDevolucionReserva = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
		return genericDao.get(DDDevolucionReserva.class, filtroDevolucionReserva);
	}

}
