package es.pfsgroup.plugin.recobro.bpm.managers.impl;

import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.controlcalidad.manager.api.ControlCalidadManager;
import es.pfsgroup.plugin.controlcalidad.model.ControlCalidadProcedimientoDto;
import es.pfsgroup.plugin.recobro.bpm.constants.RecobroConstantsBPM.Genericas;
import es.pfsgroup.plugin.recobro.bpm.constants.RecobroConstantsBPM.ManagerBPM;
import es.pfsgroup.plugin.recobro.bpm.managers.api.RecobroManagerBPMAPI;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.model.RecobroPagoContrato;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.manager.api.RecobroAccionesExtrajudicialesManagerApi;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroAccionesExtrajudiciales;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroDDResultadoGestionTelefonica;
import es.pfsgroup.recovery.recobroCommon.contrato.model.CicloRecobroContrato;
import es.pfsgroup.recovery.recobroCommon.expediente.model.CicloRecobroExpediente;
import es.pfsgroup.recovery.recobroCommon.expediente.model.CicloRecobroExpedienteTareaNotificacion;
import es.pfsgroup.recovery.recobroCommon.expediente.model.ExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroDDTipoMetaVolante;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroMetaVolante;

/**
 * Manager de operaciones de negocio para el procedimiento de metas volantes de
 * Recobro
 * 
 * @author Guillem
 *
 */
@Service("RecobroManagerBPM")
public class RecobroManagerBPMImpl implements RecobroManagerBPMAPI {

	private static final Log logger = LogFactory
			.getLog(RecobroManagerBPMImpl.class);

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private RecobroAccionesExtrajudicialesManagerApi recobroAccionesExtrajudicialesManager;

	@Autowired
	private EXTTareaNotificacionManager tareaNotificacionManager;

	@Autowired
	private ControlCalidadManager controlCalidadManager;

	@Autowired
	protected ApiProxyFactory proxyFactory;

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(ManagerBPM.BO_RECOBRO_MANAGER_BPM_COMPROBAR_META_VOLANTE)
	public boolean comprobarMetaVolante(Long idExpediente) {
		ExpedienteRecobro expediente = null;
		Boolean result = false;
		try {
			expediente = genericDao.get(ExpedienteRecobro.class,
					genericDao.createFilter(FilterType.EQUALS, Genericas.ID,
							idExpediente));
			if (!Checks.esNulo(expediente)) {
				List<RecobroMetaVolante> listaMetasVolantes = expediente
						.getCicloRecobroActivo().getSubcartera()
						.getItinerarioMetasVolantes().getMetasItinerario();
				Date fechaAltaCicloRecobroActivo = expediente
						.getCicloRecobroActivo().getFechaAlta();
				RecobroMetaVolante recobroMetaVolante = obtenerMetaVolanteActual(
						listaMetasVolantes, fechaAltaCicloRecobroActivo);
				if (Checks.esNulo(recobroMetaVolante)) {
					return true;
				}
				return compruebaMetaVolante(recobroMetaVolante, expediente);
			}
		} catch (Throwable e) {
			logger.error(
					"Se ha producido un error en el método comprobarMetaVolante de la clase RecobroManagerBPMImpl",
					e);
			if (Checks.esNulo(expediente))
				expediente = genericDao.get(ExpedienteRecobro.class, genericDao
						.createFilter(FilterType.EQUALS, Genericas.ID,
								idExpediente));
			ControlCalidadProcedimientoDto controlCalidadProcedimientoDto = new ControlCalidadProcedimientoDto();
			controlCalidadProcedimientoDto
					.setDescripcion("Se ha producido un error calculando el timer para el expediente: "
							+ expediente.getId());
			controlCalidadProcedimientoDto.setIdBPM(expediente.getProcessBpm());
			controlCalidadProcedimientoDto.setIdEntidad(expediente.getId());
			controlCalidadManager
					.registrarIncidenciaProcedimientoRecobro(controlCalidadProcedimientoDto);
			throw new UserException("bpm.error.script");
		}
		return result;

	}

	/**
	 * Comprueba una meta volantate específica
	 * 
	 * @param recobroMetaVolante
	 * @return
	 */
	private Boolean compruebaMetaVolante(RecobroMetaVolante recobroMetaVolante,
			ExpedienteRecobro expediente) {
		Boolean result = false;
		try {
			if (recobroMetaVolante
					.getTipoMeta()
					.getCodigo()
					.equals(RecobroDDTipoMetaVolante.RCF_TIPO_META_INTENTO_CONTACTO)) {
				result = compruebaExistenAccionesExtrajudiciales(
						RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_CONTACTO_NO_UTIL,
						expediente);
				if (!result)
					result = compruebaExistenAccionesExtrajudiciales(
							RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_SIN_CONTACTO,
							expediente);
				if (!result)
					result = compruebaExistenAccionesExtrajudiciales(
							RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_BUZON,
							expediente);
				if (!result)
					result = compruebaExistenAccionesExtrajudiciales(
							RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_COMUNICA,
							expediente);
				if (!result)
					result = compruebaExistenAccionesExtrajudiciales(
							RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_NO_EXISTE,
							expediente);
				if (!result)
					result = compruebaExistenAccionesExtrajudiciales(
							RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_NO_CORRESPONDE,
							expediente);
			} else if (recobroMetaVolante
					.getTipoMeta()
					.getCodigo()
					.equals(RecobroDDTipoMetaVolante.RCF_TIPO_META_CONTACTO_UTIL)) {
				result = compruebaExistenAccionesExtrajudiciales(
						RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_CONTACTO_UTIL,
						expediente);
			} else if (recobroMetaVolante
					.getTipoMeta()
					.getCodigo()
					.equals(RecobroDDTipoMetaVolante.RCF_TIPO_META_COMPROMISO_PAGO)) {
				result = compruebaExistenAccionesExtrajudiciales(
						RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_COMPROMISO_PAGO_PARCIAL,
						expediente);
				if (!result)
					result = compruebaExistenAccionesExtrajudiciales(
							RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_COMPROMISO_PAGO_TOTAL,
							expediente);
			} else if (recobroMetaVolante
					.getTipoMeta()
					.getCodigo()
					.equals(RecobroDDTipoMetaVolante.RCF_TIPO_META_COBRO_PARCIAL)) {
				result = compruebaMetaVolanteCobroParcial(recobroMetaVolante,
						expediente);
			} else if (recobroMetaVolante
					.getTipoMeta()
					.getCodigo()
					.equals(RecobroDDTipoMetaVolante.RCF_TIPO_META_CONTACTO_UTIL)) {
				result = compruebaMetaVolanteCobroTotal(recobroMetaVolante,
						expediente);
			}
			registrarEventoComprobacionMetasVolantesProcedimientoRecobro(
					result, recobroMetaVolante.getTipoMeta().getDescripcion(),
					expediente.getCicloRecobroActivo());
		} catch (Throwable e) {
			logger.error(
					"Se ha producido un error en el método compruebaMetaVolante de la clase RecobroManagerBPMImpl",
					e);
			throw new UserException("bpm.error.script");
		}
		return result;
	}

	/**
	 * Comprueba que se ha cumplido la meta volante contacto no útil
	 * 
	 * @param codigoResultadoGestionTelefonica
	 * @param expediente
	 * @return
	 */
	private Boolean compruebaExistenAccionesExtrajudiciales(
			String codigoResultadoGestionTelefonica,
			ExpedienteRecobro expediente) {
		List<RecobroAccionesExtrajudiciales> recobroAccionesExtrajudiciales;
		Boolean result = false;
		try {
			// Obtenemos los contratos del ciclo de recobro activo
			List<CicloRecobroContrato> ciclosRecobroContrato = expediente
					.getCicloRecobroActivo().getCiclosRecobroContrato();
			// Obtenemos la fecha de alta del ciclo de recobro activo
			Date fechaAlta = expediente.getCicloRecobroActivo().getFechaAlta();
			// Para cada contrato sin fecha de baja vemos si tiene cobros
			// parciales
			for (CicloRecobroContrato cicloRecobroContrato : ciclosRecobroContrato) {
				recobroAccionesExtrajudiciales = recobroAccionesExtrajudicialesManager
						.obtenerAccionesExtrajudicialesPorAgenciaContratoResultadoFechaGestion(
								expediente.getCicloRecobroActivo().getAgencia(),
								cicloRecobroContrato.getContrato(),
								fechaAlta,
								genericDao
										.get(RecobroDDResultadoGestionTelefonica.class,
												genericDao
														.createFilter(
																FilterType.EQUALS,
																Genericas.CODIGO,
																codigoResultadoGestionTelefonica)));
				if (recobroAccionesExtrajudiciales.size() > 0)
					return true;
			}
		} catch (Throwable e) {
			logger.error(
					"Se ha producido un error en el método compruebaExistenAccionesExtrajudiciales de la clase RecobroManagerBPMImpl",
					e);
			throw new UserException("bpm.error.script");
		}
		return result;
	}

	/**
	 * Comprueba que se ha cumplido la meta volante de cobro parcial
	 * 
	 * @param recobroMetaVolante
	 * @param expediente
	 * @return
	 */
	private Boolean compruebaMetaVolanteCobroParcial(
			RecobroMetaVolante recobroMetaVolante, ExpedienteRecobro expediente) {
		List<RecobroPagoContrato> recobroPagosContrato = null;
		Boolean result = false;
		Float acumulado = new Float(0);
		try {
			// Obtenemos los contratos del ciclo de recobro activo
			List<CicloRecobroContrato> ciclosRecobroContrato = expediente
					.getCicloRecobroActivo().getCiclosRecobroContrato();
			// Obtenemos la configuración para el cobro parcial
			Float porcentaje = recobroMetaVolante.getItinerario()
					.getPorcentajeCobroParcial();
			// Obtenemos la fecha de alta del ciclo de recobro activo
			Date fechaAlta = expediente.getCicloRecobroActivo().getFechaAlta();
			// Para cada contrato sin fecha de baja vemos si tiene cobros
			// parciales
			for (CicloRecobroContrato cicloRecobroContrato : ciclosRecobroContrato) {
				// Obtenemos todos los cobros del contrato
				recobroPagosContrato = genericDao.getList(
						RecobroPagoContrato.class, genericDao.createFilter(
								FilterType.EQUALS, Genericas.CONTRATO,
								cicloRecobroContrato.getContrato()));
				// Para cada cobro del contrato que se haya producido después de
				// la fecha de alta del ciclo de recobro
				for (RecobroPagoContrato recobroPagoContrato : recobroPagosContrato) {
					if (getDateDiff(recobroPagoContrato.getFechaValor(),
							fechaAlta, TimeUnit.DAYS) > 0) {
						acumulado = recobroPagoContrato.getCapital()
								+ recobroPagoContrato.getComisiones()
								+ recobroPagoContrato.getImpuestos()
								+ recobroPagoContrato.getInteresesMoratorios()
								+ recobroPagoContrato.getInteresesOrdinarios()
								+ recobroPagoContrato.getGastos();
					}
				}
			}
			// Comprobamos si se ha superado el porcentaje configurado
			if ((acumulado / (expediente.getCicloRecobroActivo()
					.getPosVivaVencida())) > porcentaje)
				return true;
		} catch (Throwable e) {
			logger.error(
					"Se ha producido un error en el método compruebaMetaVolanteCobroParcial de la clase RecobroManagerBPMImpl",
					e);
			throw new UserException("bpm.error.script");
		}
		return result;
	}

	/**
	 * Comprueba que se ha cumplido la meta volante de cobro total
	 * 
	 * @param recobroMetaVolante
	 * @param expediente
	 * @return
	 */
	private Boolean compruebaMetaVolanteCobroTotal(
			RecobroMetaVolante recobroMetaVolante, ExpedienteRecobro expediente) {
		Boolean result = false;
		try {
			// Para comprobar la meta volante de cobro total hay que ver si la
			// suma de la deuda irregular de todos sus contratos es <= 0
			if (expediente.getVolumenRiesgoVencido() <= 0) {
				return true;
			}
		} catch (Throwable e) {
			logger.error(
					"Se ha producido un error en el método compruebaMetaVolanteCobroParcial de la clase RecobroManagerBPMImpl",
					e);
			throw new UserException("bpm.error.script");
		}
		return result;
	}

	/**
	 * Registra una notificación y su relación con el ciclo de recobro del
	 * expediente
	 * 
	 * @param validacion
	 * @param metaVolante
	 * @param cicloRecobroExpediente
	 */
	private void registrarEventoComprobacionMetasVolantesProcedimientoRecobro(
			Boolean validacion, String metaVolante,
			CicloRecobroExpediente cicloRecobroExpediente) {
		String codigoTipoEvento = Genericas.REC_META_VOL_KO;
		String descripcionEvento = Genericas.META_VOLANTE_INCUMPLIDA
				+ metaVolante;
		try {
			if (validacion) {
				codigoTipoEvento = Genericas.REC_META_VOL_OK;
				descripcionEvento = Genericas.META_VOLANTE_CUMPLIDA
						+ metaVolante;
			}
			Long idNotificacion = tareaNotificacionManager.crearNotificacion(
					cicloRecobroExpediente.getExpediente().getId(),
					DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, codigoTipoEvento,
					descripcionEvento);
			CicloRecobroExpedienteTareaNotificacion cicloRecobroExpedienteTareaNotificacion = new CicloRecobroExpedienteTareaNotificacion();
			cicloRecobroExpedienteTareaNotificacion
					.setCicloRecobroExpediente(cicloRecobroExpediente);
			cicloRecobroExpedienteTareaNotificacion
					.setTareaNotificacion(genericDao.get(
							EXTTareaNotificacion.class, genericDao
									.createFilter(FilterType.EQUALS,
											Genericas.ID, idNotificacion)));
			genericDao.save(CicloRecobroExpedienteTareaNotificacion.class,
					cicloRecobroExpedienteTareaNotificacion);
		} catch (Throwable e) {
			logger.error(
					"Se ha producido un error en el método registrarEventoProcedimientoRecobro de la clase RecobroManagerBPMImpl",
					e);
			throw new UserException("bpm.error.script");
		}
	}

	/**
	 * Obtiene la meta volante actual configurada según su fecha de alta del
	 * ciclo activo de recobro
	 * 
	 * @param listaMetasVolantes
	 * @param fechaAltaCicloRecobroActivo
	 * @return
	 */
	private RecobroMetaVolante obtenerMetaVolanteActual(
			List<RecobroMetaVolante> listaMetasVolantes,
			Date fechaAltaCicloRecobroActivo) {
		RecobroMetaVolante resultado = null;
		try {
			Long diasDiferencia = getDateDiff(fechaAltaCicloRecobroActivo,
					new Date(System.currentTimeMillis()), TimeUnit.DAYS);

			if (diasDiferencia != null) {
				for (RecobroMetaVolante recobroMetaVolante : listaMetasVolantes) {
					// Realizamos la resta de diasDiferencia -
					// recobroMetaVolante.getDiasDesdeEntrega() para compararlos
					// evitando casteos al ser tipos diferentes.
					Long diff = diasDiferencia;
					if (recobroMetaVolante.getDiasDesdeEntrega() != null) {
						diff -= recobroMetaVolante.getDiasDesdeEntrega();
					}

					if (diff == 0) {
						return recobroMetaVolante;
					}
				}
			}
		} catch (Throwable e) {
			logger.error(
					"Se ha producido un error en el método obtenerMetaVolanteActual de la clase RecobroManagerBPMImpl",
					e);
			throw new UserException("bpm.error.script");
		}
		return resultado;
	}

	/**
	 * Get a diff between two dates
	 * 
	 * @param date1
	 *            the oldest date
	 * @param date2
	 *            the newest date
	 * @param timeUnit
	 *            the unit in which you want the diff
	 * @return the diff value, in the provided unit. Return NULL if one of the
	 *         arguments is NULL
	 */
	private static Long getDateDiff(Date date1, Date date2, TimeUnit timeUnit) {
		if ((date1 == null || date2 == null)) {
			return null;
		}
		long diffInMillies = date2.getTime() - date1.getTime();
		return timeUnit.convert(diffInMillies, TimeUnit.MILLISECONDS);
	}

}
