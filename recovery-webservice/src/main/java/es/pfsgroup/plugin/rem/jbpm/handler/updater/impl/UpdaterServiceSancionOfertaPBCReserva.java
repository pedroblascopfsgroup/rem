package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoOferta.ActivoOfertaPk;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;

@Component
public class UpdaterServiceSancionOfertaPBCReserva implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	private static final String CODIGO_T017_PBC_RESERVA = "T017_PBCReserva";
	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaPBCReserva.class);

	private static final String COMBO_RESPUESTA = "comboRespuesta";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String CODIGO_ANULACION_IRREGULARIDADES = "601";
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	@Override
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());

			if (!Checks.esNulo(expediente)) {

				for (TareaExternaValor valor : valores) {

					if (COMBO_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {

						if (ofertaApi.checkReserva(ofertaAceptada)) {
							if (DDSiNo.NO.equals(valor.getValor())) {
								Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
										DDEstadosExpedienteComercial.ANULADO);
								DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class,
										filtro);
								expediente.setEstado(estado);
								expediente.setFechaVenta(null);
								expediente.setEstadoPbcR(0);
								expediente.setFechaAnulacion(new Date());

								genericDao.save(ExpedienteComercial.class, expediente);

								// Finaliza el trámite
								Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo",
										CODIGO_TRAMITE_FINALIZADO);
								tramite.setEstadoTramite(
										genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
								genericDao.save(ActivoTramite.class, tramite);

								// Rechaza la oferta y descongela el resto
								ofertaApi.rechazarOferta(ofertaAceptada);
								for (ActivoOferta actOfr : ofertaAceptada.getActivosOferta()) {
									ActivoOfertaPk actOfrePk = actOfr.getPrimaryKey();
									Activo act = actOfrePk.getActivo();

									GestorEntidadDto gestorEntidadDto = new GestorEntidadDto();
									gestorEntidadDto.setIdEntidad(act.getId());
									gestorEntidadDto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO);
									List<GestorEntidadHistorico> listaGestores = gestorActivoApi
											.getListGestoresActivosAdicionalesHistoricoData(gestorEntidadDto);
									for (GestorEntidadHistorico gestor : listaGestores) {
										if ((GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION
												.equals(gestor.getTipoGestor().getCodigo())
												|| GestorActivoApi.CODIGO_GESTOR_FORMALIZACION
														.equals(gestor.getTipoGestor().getCodigo())
												|| GestorActivoApi.CODIGO_GESTOR_FORMALIZACION_ADMINISTRACION
														.equals(gestor.getTipoGestor().getCodigo()))
												&& !Checks.esNulo(gestor.getUsuario().getEmail())) {

											enviarCorreoAnularOfertaActivo(act, gestor.getUsuario().getEmail());
										}
									}
								}

								try {
									ofertaApi.descongelarOfertas(expediente);
								} catch (Exception e) {
									logger.error("Error descongelando ofertas.", e);
								}

							} else {
								expediente.setEstadoPbcR(1);
								genericDao.save(ExpedienteComercial.class, expediente);

							}

							// Motivo anulación
							if (!ofertaApi.checkReserva(ofertaAceptada) && DDSiNo.NO.equals(valor.getValor())) {
								Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
										CODIGO_ANULACION_IRREGULARIDADES);
								DDMotivoAnulacionExpediente motivoAnulacion = (DDMotivoAnulacionExpediente) genericDao
										.get(DDMotivoAnulacionExpediente.class, filtro);
								expediente.setMotivoAnulacion(motivoAnulacion);

								DDTipoRechazoOferta tipoRechazo = (DDTipoRechazoOferta) utilDiccionarioApi
										.dameValorDiccionarioByCod(DDTipoRechazoOferta.class,
												DDTipoRechazoOferta.CODIGO_ANULADA);

								DDMotivoRechazoOferta motivoRechazo = (DDMotivoRechazoOferta) utilDiccionarioApi
										.dameValorDiccionarioByCod(DDMotivoRechazoOferta.class,
												motivoAnulacion.getCodigo());

								motivoRechazo.setTipoRechazo(tipoRechazo);
								ofertaAceptada.setMotivoRechazo(motivoRechazo);
								genericDao.save(Oferta.class, ofertaAceptada);
							}
						}
					}
				}
			}
		}
	}

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}
    @Override
	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_PBC_RESERVA };
	}

	private Boolean enviarCorreoAnularOfertaActivo(Activo activo, String email) {
		boolean resultado = false;

		try {
			ArrayList<String> mailsPara = new ArrayList<String>();
			mailsPara.add(email);
			String asunto = "Anulación de la oferta del activo " + activo.getNumActivo();
			String cuerpo = "<p>Se ha anulado la oferta del activo " + activo.getNumActivo() + "<br></br>" + "<br></br>"
					+ "Un saludo. </p>";

			genericAdapter.sendMail(mailsPara, new ArrayList<String>(), asunto, cuerpo);
			resultado = true;
		} catch (Exception e) {
			logger.error("No se ha podido notificar la anulación de la oferta del activo.", e);
		}

		return resultado;
	}

}
