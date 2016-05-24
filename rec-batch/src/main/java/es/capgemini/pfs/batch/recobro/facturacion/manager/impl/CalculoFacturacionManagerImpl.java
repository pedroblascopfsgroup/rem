package es.capgemini.pfs.batch.recobro.facturacion.manager.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.batch.recobro.facturacion.manager.CalculoFacturacionManager;
import es.capgemini.pfs.batch.recobro.facturacion.manager.RecobroCobrosPagosManager;
import es.capgemini.pfs.batch.recobro.facturacion.manager.RecobroControlCobrosManager;
import es.capgemini.pfs.batch.recobro.facturacion.manager.RecobroDetalleFacturaTemporalManager;
import es.capgemini.pfs.batch.recobro.facturacion.model.RecobroDetalleFacturacionCorrectorTemporal;
import es.capgemini.pfs.batch.recobro.facturacion.model.RecobroDetalleFacturacionTemporal;
import es.capgemini.pfs.batch.recobro.reparto.manager.RecobroRepartoManager;
import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroCobroFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroCorrectorFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroTarifaCobro;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroTarifaCobroTramo;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.api.RecobroDetalleFacturacionApi;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.api.RecobroProcesoFacturacionSubcarteraApi;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.api.RecobroProcesosFacturacionApi;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.EXTRecobroCobroPago;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroCobroPreprocesado;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroDDEstadoProcesoFacturable;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacion;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacionSubcartera;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingHistoricoSubcartera;
import es.pfsgroup.recovery.recobroCommon.ranking.model.api.RecobroRankingSubcarteraManagerApi;

/**
 * Implementaci�n del interfaz de c�lculo de la facturaci�n para las Agencias de
 * Recobro
 * 
 * @author Guillem
 * 
 */
@Service
public class CalculoFacturacionManagerImpl implements CalculoFacturacionManager {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RecobroProcesosFacturacionApi recobroProcesosFacturacionManager;

	@Autowired
	private RecobroProcesoFacturacionSubcarteraApi recobroProcesoFacturacionSubcarteraManager;

	@Autowired
	private RecobroControlCobrosManager recobroControlCobrosManager;

	@Autowired
	private RecobroCobrosPagosManager recobroCobrosPagosManager;

	@Autowired
	private RecobroDetalleFacturaTemporalManager recobroDetalleFacturaTemporalManager;
	
	@Autowired
	private RecobroDetalleFacturacionApi recobroDetalleFacturacionManager;
	
	@Autowired
	private RecobroRankingSubcarteraManagerApi recobroRankingSubcarteraManager;

	@Autowired
	private RecobroRepartoManager recobroRepartoManager;

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void calcularFacturacion() {
		// Obtenemos los procesos de facturaci�n pendientes
		List<RecobroProcesoFacturacion> procesosFacturacionPendientes = recobroProcesosFacturacionManager.getProcesosByState(RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PENDIENTE);
		if (procesosFacturacionPendientes.size() == 1) {
			// Por cada uno de los procesos obtenidos
			for (RecobroProcesoFacturacion recobroProcesoFacturacion : procesosFacturacionPendientes) {
				// Comprobamos que tenemos todos los cobros para las fechas del
				// proceso preprocesadas
				if (this.comprobarTodosDiasEstanProcesados(recobroProcesoFacturacion.getFechaDesde(), recobroProcesoFacturacion.getFechaHasta())) {
					try {
						// Si es la primera vez que se procesa este proceso de
						// facturación
						// hay que rellenar la tabla PFS_PROC_FAC_SUBCARTERA con
						// los totales = 0
						gestionarProcesosFacturacion(recobroProcesoFacturacion);
						//FIXME Eliminar esta línea procesarProcesoFacturacion(recobroProcesoFacturacion);
						recobroDetalleFacturaTemporalManager.procesaProcesoFacturacion();
						transferirDetalleFacturacionTemporalAProduccion();
						// Actualiza los totales de la tabla PFS_PROC_FAC_SUBCARTERA
						actualizarProcesoFacturacion(recobroProcesoFacturacion);

						//Generamos la excel de facturación para que sea inmediato cuando le dén descargar
						recobroProcesosFacturacionManager.generarExcelProcesosFacturacion(recobroProcesoFacturacion.getId());
						recobroProcesosFacturacionManager.generarExcelProcesosFacturacionReducido(recobroProcesoFacturacion.getId());
						
						recobroProcesosFacturacionManager.cambiaEstadoProcesoFacturacion(recobroProcesoFacturacion.getId(), RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PROCESADO);						
					} catch (Exception e) {
						recobroProcesosFacturacionManager
								.cambiaEstadoProcesoFacturacion(recobroProcesoFacturacion.getId(), 
										RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_CON_ERRORES,
										e.getMessage());
						logger.error("Se ha producido una excepci�n al realizar el procesado de la facturaci�n en el m�todo calcularFacturaci�n : ", e);
					} catch (Throwable e) {
						recobroProcesosFacturacionManager
								.cambiaEstadoProcesoFacturacion(recobroProcesoFacturacion.getId(), 
										RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_CON_ERRORES,
										e.getMessage());
						logger.error("Se ha producido una excepci�n al realizar el procesado de la facturaci�n en el m�todo calcularFacturaci�n : ", e);
					}
				} else {
					logger.info("No se realizar� el c�lculo de la facturaci�n porque existen d�as dentro del periodo de facturaci�n que no han sido procesados.");
				}
			}
		} else {
			logger.info("No se realizar� el c�lculo de la facturaci�n porque existen mas de ún procesos de facturaci�n pendiente.");
		}
	}

	/**
	 * Se rellena la tabla PFS_PROC_FAC_SUBCARTERA para el primer procesado del
	 * proceso de recobro
	 * 
	 * @param recobroProcesoFacturacion
	 * @throws Exception 

	 */
	@Transactional(readOnly = false)
	private void gestionarProcesosFacturacion(RecobroProcesoFacturacion recobroProcesoFacturacion) throws Exception {
		try {
			// Averiguamos si existen registros en PFS_PROC_FAC_SUBCARTERA con el
			// PRF_ID del proceso
			// Y si no hay registros entonces es la primera vez y los creamos
			if (recobroProcesoFacturacion.getProcesoSubcarteras() == null || recobroProcesoFacturacion.getProcesoSubcarteras().size() == 0) {
				// Obtenemos las subcarteras de los cobro pagos preprocesados entre
				// estas fechas
				List<RecobroSubCartera> recobroSubCarteras = recobroControlCobrosManager.getSubcarterasCobrosPagosPorFechas(recobroProcesoFacturacion.getFechaDesde(),
						recobroProcesoFacturacion.getFechaHasta());
	
				if (recobroSubCarteras != null) {
					List<RecobroProcesoFacturacionSubcartera> listPfs = new ArrayList<RecobroProcesoFacturacionSubcartera>();
	
					// Rellenamos un registro por cada subcartera del proceso de
					// facturación.
					for (RecobroSubCartera recobroSubCartera : recobroSubCarteras) {
						RecobroProcesoFacturacionSubcartera pfs = new RecobroProcesoFacturacionSubcartera();
						pfs.setProcesoFacturacion(recobroProcesoFacturacion);
						pfs.setSubCartera(recobroSubCartera);
						pfs.setModeloFacturacionInicial(recobroSubCartera.getModeloFacturacion());
						pfs.setTotalImporteCobros(0d);
						pfs.setTotalImporteFacturable(0d);
						recobroProcesoFacturacionSubcarteraManager.saveProcesoFacturacion(pfs);
	
						listPfs.add(pfs);
					}
	
					// Y guardamos los nuevos registros de PFS_PROC_FAC_SUBCARTERA
					// en el objeto recobroProcesFacturacion pasado
					recobroProcesoFacturacion.setProcesoSubcarteras(listPfs);
				}
			}
		} catch (Exception e) {
			throw new Exception("Error al vaciar el resumen de subcarteras para el proceso de facturación\n"+e.getMessage());
		}

	}
	
	/*
	 * Se actualizan los sumatorios de la facturación en la tabla PFS_PROC_FAC_SUBCARTERA
	 */
	private void actualizarProcesoFacturacion(RecobroProcesoFacturacion recobroProcesoFacturacion) throws Exception {
		try {
			recobroProcesoFacturacionSubcarteraManager.updateSumProcesoFacturacionSubcartera(recobroProcesoFacturacion.getId().longValue());
		} catch (Exception e) {
			throw new Exception("Error al actualizar el resumen de la facturación por subcarteras.\n"+e.getMessage());
		}
	}

	/**
	 * Calcula el importe del cobro, regulando el importe segun tarifa
	 * 
	 * @param importeCobro
	 * @param minimo
	 * @param maximo
	 * @return
	 */	
	private Float corregirImporteSegunTarifa(Float importeCobro, RecobroTarifaCobro tarifa) {
		Float importe = 0.0f;
		
		if (importeCobro!=null) {
			importe = importeCobro;
	
			if (tarifa.getMinimo()!=null) {
				// Si el importe no llega al m�nimo es como si fuera 0
				if (importeCobro < tarifa.getMinimo())
					importe = 0.0f;
			}
			
			if (tarifa.getMaximo()!=null) {
				// Si el importe supera el m�ximo, aplicamos el m�ximo
				if (importeCobro > tarifa.getMaximo())
					importe = tarifa.getMaximo();
			}
		}

		return importe;
	}
	
	/**
	 * Comprueba que todos los d�as entre fechaInicio y fechaFin hayan sido
	 * procesados, comprobando si el n�mero de registros beetween esas fechas es
	 * igual al n�mero de dias entre las fechas
	 * 
	 * @param fechaInicio
	 * @param fechaFin
	 * @return True, si todos los d�as estan procesados o false en otro caso
	 */
	private boolean comprobarTodosDiasEstanProcesados(Date fechaInicio, Date fechaFin) {
		// Truncamos las fechas de los par�metros
		fechaInicio = truncDate(fechaInicio);
		fechaFin = truncDate(fechaFin);

		// Obtenemos la diferencia en d�as
		int difEnDias = getDifDias(fechaInicio, fechaFin);

		// Obtenemos cuantos registros hay para esas fechas en la tabla de
		// control
		int diasProcesados = recobroControlCobrosManager.CountNumeroRegistrosEntreDias(fechaInicio, fechaFin);

		// Se devuelve true, si la diferencia en d�as y el n�mero de registros
		// coinciden
		return (difEnDias == diasProcesados);
	}

	/**
	 * Devuelve la diferencia de dias entre dos fechas, ambas inclusive
	 * 
	 * @param fechaDesde
	 * @param fechaHasta
	 * @return la diferencia en d�as
	 */
	private int getDifDias(Date fechaDesde, Date fechaHasta) {
		// Obtenemos la diferencia en d�as
		
		GregorianCalendar cFechaDesde = new GregorianCalendar();
		cFechaDesde.setTime(fechaDesde);
		
		GregorianCalendar cFechaHasta = new GregorianCalendar();
		cFechaHasta.setTime(fechaHasta);
		
		int difEnDias = cFechaHasta.get(Calendar.DAY_OF_YEAR) - cFechaDesde.get(Calendar.DAY_OF_YEAR);
		
		//OJO el código de abajo da problemas con el mes que se cambia al horario de verano, siendo marzo de 29,9 días, que al pasar a int = 30 días
		/*long difEnMilisegundos = fechaHasta.getTime() - fechaDesde.getTime();
		int difEnDias = (int) (difEnMilisegundos / (24 * 60 * 60 * 1000));*/
		
		// Como desde y hasta son inclusives
		difEnDias++;

		return difEnDias;
	}

	/**
	 * Trunca una fecha, es decir la devuelve marcando a 0 las propiedades
	 * relativas al tiempo
	 * 
	 * @param fecha
	 *            a truncar
	 * @return fecha truncada
	 */
	private Date truncDate(Date fecha) {
		Calendar cal = Calendar.getInstance();

		cal.setTime(fecha);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);

		return cal.getTime();
	}

	/**
	 * Se devuelve el modelo de facturación para la subcartera pasada teniendo
	 * en cuenta los campos RCF_MFA_ID_ORIGINAL o RCF_MFA_ID_ACTUAL,
	 * anteponiendose el segundo, ya que eso indica una modificación del
	 * comportamiento de la subcartera
	 * 
	 * @param recobroProcesoFacturacionSubcarteras
	 * @param recobroSubCartera
	 * @return el modelo de facturacion a utlizar para la subcartera pasada,
	 *         NULL en caso de no obtenerse
	 */
	private RecobroModeloFacturacion obtenerModeloFacturacion(List<RecobroProcesoFacturacionSubcartera> recobroProcesoFacturacionSubcarteras, RecobroSubCartera recobroSubCartera) {
		for (RecobroProcesoFacturacionSubcartera recobroProcesoFacturacionSubcartera : recobroProcesoFacturacionSubcarteras) {
			// Buscamos el registro correspondiente a la cartera pasada
			if (recobroSubCartera.getId().longValue() == recobroProcesoFacturacionSubcartera.getSubCartera().getId().longValue()) {
				// Si tenemos un modelo de facturacion actual, se devuelve este
				if (recobroProcesoFacturacionSubcartera.getModeloFacturacionActual() != null)
					return recobroProcesoFacturacionSubcartera.getModeloFacturacionActual();
				// Si no se devuelve el modelo original
				return recobroProcesoFacturacionSubcartera.getModeloFacturacionInicial();
			}
		}

		// Si no se ha encontrado un registro en PFS_PROC_FAC_SUBCARTERA
		// devolvemos null, pero avisamos que esto es erroneo en el log
		logger.error("No se ha podido obtener un método de facturación para la subcartera id: " + recobroSubCartera.getId()
				+ "\n debido a que no existe el correspondiente registro en la tabla PFS_PROC_FAC_SUBCARTERA\n");
		return null;
	}

	/**
	 * Dado un proceso de Facturacion, realiza los calculos de su facturacion y
	 * los almacena
	 * 
	 * @deprecated Este método se sustituye por un PL/SQL
	 * 
	 * @param recobroProcesoFacturacion
	 * @throws Throwable
	 * 
	 */
	@Transactional(readOnly = false)
	@Deprecated
	private void procesarProcesoFacturacion(RecobroProcesoFacturacion recobroProcesoFacturacion) throws Throwable {
		try {
			try {
				// Borrar la tabla TMP_RECOBRO_DETALLE_FACTURA
				recobroDetalleFacturaTemporalManager.vaciarDetallesFacturaTemporales();
			} catch (Exception e) {
				throw new Exception("Error al intentar vaciar la tabla temporal de detalles de facturación.\n"+e.getMessage());
			}
	
			List<RecobroCobroPreprocesado> cobros;
			try {
				// Obtener los cobros asociados a los contratos de
				// cpr_cobros_pagos_recobro
				cobros = recobroCobrosPagosManager.obtenerCobrosPagosPorFechas(recobroProcesoFacturacion.getFechaDesde(), recobroProcesoFacturacion.getFechaHasta());
			} catch (Exception e) {
				throw new Exception("Error al intentar obtener los cobros preprocesados para la facturación.\n"+e.getMessage());
			}
			
			for (RecobroCobroPreprocesado cobro : cobros) {
				// Obtenemos la configuraci�n
	
				RecobroModeloFacturacion modelo;
				try {
					modelo = obtenerModeloFacturacion(recobroProcesoFacturacion.getProcesoSubcarteras(), cobro.getSubCartera());
				} catch (Exception e) {
					throw new Exception("Error al intentar obtener el modelo de facturación para la subcartera: " +  cobro.getSubCartera().getNombre() + "\n"+e.getMessage());
				}
	
				RecobroCobroFacturacion tipoCobro;
				try {
					tipoCobro = obtenerRecobroCobroFacturacion(modelo.getCobrosAsociados(), cobro.getCobroPago().getSubTipo());
				} catch (Exception e) {
					throw new Exception("Error al intentar obtener el tipo del cobro: " +  cobro.getCobroPago().getCodigoCobro() + "\n"+e.getMessage());
				}
				if (tipoCobro != null) {
					List<RecobroTarifaCobro> tarifas;
					try {
						tarifas = tipoCobro.getTarifasCobro();
					} catch (Exception e) {
						throw new Exception("Error al intentar obtener las tarifas para el tipo de cobro: " +  tipoCobro.getTipoCobro().getDescripcion() + "\n"+e.getMessage());
					}
					for (RecobroTarifaCobro tarifa : tarifas) {
						Float importe;
						try {
							importe = this.obtenerImporteSegunConcepto(cobro.getCobroPago(), tarifa.getTipoTarifa().getCampoConceptoImporte());
						} catch (Exception e) {
							throw new Exception("Error al intentar obtener el importe del cobro.\n"+e.getMessage());
						}							
	
						// Si el importe del cobro es 0, no hay nada que facturar
						// para esta tarifa
						if (importe != null && importe != 0) {
							Float porcentaje;
							Float importeReal;
							
							try {
								porcentaje = this.obtenerPorcentajeComision(cobro, tarifa);
							} catch (Exception e) {
								throw new Exception("Error al intentar obtener el porcentaje de comisión del cobro: " + cobro.getCobroPago().getCodigoCobro() +
										" para la tarifa de tipo: " + tarifa.getTipoTarifa().getDescripcion() + "\n"+e.getMessage());
							}							
							importeReal = this.corregirImporteSegunTarifa(importe, tarifa);
	
							Float comision;
							try {
								//Aplicamos el porcentaje sobre el importe regularizado
								comision = (importeReal * porcentaje) / 100;
							} catch (Exception e) {
								throw new Exception("Error al intentar obtener la comisión del cobro: " + cobro.getCobroPago().getCodigoCobro() + 
										" para la tarifa de tipo: " + tarifa.getTipoTarifa().getDescripcion() +"\n"+e.getMessage());
							}
	
							// Si por el importe mínimo o por el porcentaje la
							// comisión es 0, no se inserta
							if (comision != null && comision != 0) {
								try {
									// Guardar en la TMP el cobro.
									RecobroDetalleFacturacionTemporal detalle = new RecobroDetalleFacturacionTemporal();
									detalle.setAgencia(cobro.getAgencia());
									detalle.setCobroPago(cobro.getCobroPago());
									detalle.setContrato(cobro.getContrato());
									detalle.setExpediente(cobro.getExpediente());
									detalle.setFechaCobro(cobro.getFecha());
									detalle.setImporteConceptoFacturable(importe.doubleValue());
									detalle.setImporteRealFacturable(importeReal.doubleValue());
									detalle.setImporteAPagar(comision.doubleValue());
									detalle.setPorcentaje(porcentaje);
									detalle.setProcesoFacturacionSubcartera(obtenerProcesoFacturacionSubcartera(recobroProcesoFacturacion.getProcesoSubcarteras(), cobro.getSubCartera()));
									detalle.setSubCartera(cobro.getSubCartera());
									detalle.setTarifaCobro(tarifa);
									recobroDetalleFacturaTemporalManager.insertarDetalleTemporalFacturacion(detalle);
								} catch (Exception e) {
									throw new Exception("Error al intentar grabar el detalle de facturación para el cobro: " + cobro.getCobroPago().getCodigoCobro() +
											" para la tarifa de tipo: " + tarifa.getTipoTarifa().getDescripcion() + "\n"+e.getMessage());
								}									
							}
						}
					}
				}
			}
		} catch (Exception e) {
			throw new Exception("Error durante el bucle principal de los detalles de la facturación.\n"+e.getMessage());
		}
		
		try {
			//Aplicamos los correctores
			aplicarCorrectores(recobroProcesoFacturacion);
		} catch (Exception e) {
			throw new Exception("Error al aplicar los correctores.\n"+e.getMessage());
		}
		
		try {
			// Transferimos la facturaci�n con los correctores aplicados a las
			// tablas de producci�n
			transferirDetalleFacturacionTemporalAProduccion();
		} catch (Exception e) {
			throw new Exception("Error al grabar el proceso de facturación es las tablas finales.\n"+e.getMessage());
		}
	}

	/**
	 * Devuelve el objeto de tipo CobroPago que corresponde
	 * 
	 * @param recobroCobrosFacturacion
	 *            Lista de tipos de cobros
	 * @param tipoCobroPago
	 *            Tipo del cobro pago
	 * @return null si no lo encuentra en la lista pasada
	 */
	private RecobroCobroFacturacion obtenerRecobroCobroFacturacion(List<RecobroCobroFacturacion> recobroCobrosFacturacion, DDSubtipoCobroPago subTipoCobroPago) {
		for (RecobroCobroFacturacion recobroCobroFacturacion : recobroCobrosFacturacion) {
			if (recobroCobroFacturacion.getTipoCobro().getCodigo().equals(subTipoCobroPago.getCodigo())) {
				return recobroCobroFacturacion;
			}
		}
		return null;
	}
	
	
	/**
	 * Devuelve el importe indicado del campo correspondiente del objeto
	 * CobroPago seg�n el concepto
	 * 
	 * @param cobroPago
	 * @param concepto
	 * @return null en caso que el concepto no coincida con ninguno de los casos
	 */	
    private Float obtenerImporteSegunConcepto(EXTRecobroCobroPago cobroPago, String concepto) {
		Float importe = null;

		if (concepto.toUpperCase().equals("CPA_CAPITAL"))
			importe = cobroPago.getCapital();

		if (concepto.toUpperCase().equals("CPA_CAPITAL_NO_VENCIDO"))
			importe = cobroPago.getCapitalNoVencido();

		if (concepto.toUpperCase().equals("CPA_INTERESES_ORDINAR"))
			importe = cobroPago.getInteresesOrdinarios();

		if (concepto.toUpperCase().equals("CPA_INTERESES_MORATOR"))
			importe = cobroPago.getInteresesMoratorios();

		if (concepto.toUpperCase().equals("CPA_COMISIONES"))
			importe = cobroPago.getComisiones();

		if (concepto.toUpperCase().equals("CPA_GASTOS"))
			importe = cobroPago.getGastos();

		return importe;
	}	

	// private RecobroTarifaCobro
	// obtenerRecobroTarifaCobro(List<RecobroTarifaCobro> recobroTarifasCobro);

	/**
	 * Obtiene el proceso de facturacion de la subcartera, de la subcartera del
	 * cobro
	 * 
	 * @param recobroProcesoFacturacionSubcarteras
	 * @param recobroSubCartera
	 * @return
	 */
	private RecobroProcesoFacturacionSubcartera obtenerProcesoFacturacionSubcartera(List<RecobroProcesoFacturacionSubcartera> recobroProcesoFacturacionSubcarteras, RecobroSubCartera recobroSubCartera) {
		for (RecobroProcesoFacturacionSubcartera recobroProcesoFacturacionSubcartera : recobroProcesoFacturacionSubcarteras) {
			if (recobroProcesoFacturacionSubcartera.getSubCartera().equals(recobroSubCartera)) {
				return recobroProcesoFacturacionSubcartera;
			}
		}
		return null;
	}

	/**
	 * Obtiene el porcentaje del cobro, en modo facturacion estatico
	 * 
	 * @param cobro
	 * @param tarifa
	 * @return
	 */
	private Float obtenerPorcentajeComision(RecobroCobroPreprocesado cobro, RecobroTarifaCobro tarifa) {
		Float porcentaje = null;
		List<RecobroTarifaCobroTramo> tramos = tarifa.getTarifasCobrosTramos();

		// Obtenemos cuantos dias lleva el pago en la agencia:
		int dias = getNumDiasCntEnAgencia(cobro.getFecha(), cobro.getContrato().getId(), cobro.getAgencia().getId(), cobro.getSubCartera().getId());
		int n = 0;

		// Obtenemos el porcentaje teniendo en cuenta el d�a y los tramos
		while (n < tramos.size() && porcentaje == null) {
			if (dias <= tramos.get(n).getTramoFacturacion().getTramoDias())
				porcentaje = tramos.get(n).getPorcentaje();

			n++;
		}

		// Si no hemos conseguido un porcentaje se usa el de por defecto
		if (porcentaje == null) 
			porcentaje = tarifa.getPorcentajePorDefecto();
		
		if (porcentaje == null)
			porcentaje = 0.0f; //Para no devolver null y de un null pointer exception

		return porcentaje;
	}

	/**
	 * Indica cuanto tiempo lleva un contrato en una agencia/subcartera en d�as
	 * para el d�a del pago
	 * 
	 * @param fechaPago
	 * @param cntId
	 * @param ageId
	 * @param subId
	 * @return
	 */
	private int getNumDiasCntEnAgencia(Date fechaPago, long cntId, long ageId, long subId) {
		Date fechaReparto = recobroRepartoManager.FechaEntradaCntAgeSub(cntId, ageId, subId);

		return getDifDias(fechaReparto, fechaPago);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void aplicarCorrectores(RecobroProcesoFacturacion recobroProcesoFacturacion) throws Throwable {
		try {
			//Vaciamos la tabla de detalles corregidos
			recobroDetalleFacturaTemporalManager.vaciarDetallesFacturaTemporalesCo();
		} catch (Exception e) {
			throw new Exception("Error al intentar vaciar la tabla temporal de detalles de facturación con correctores.\n"+e.getMessage());
		}
		
		RecobroDetalleFacturacionCorrectorTemporal recobroDetalleFacturacionCorrectorTemporal;
		RecobroCorrectorFacturacion recobroCorrectorFacturacion;

		List<RecobroSubCartera> recobroSubCarteras;
		try {
			// Obtenemos las distintas subcarteras para las que existen cobros en la
			// tabla TMP_RECOBRO_DETALLE_FACTURA
			recobroSubCarteras = recobroDetalleFacturaTemporalManager.obtenerSubcarterasExistentes();
		} catch (Exception e) {
			throw new Exception("Error al intentar obtener las subcarteras de los detalles de facturación.\n"+e.getMessage());
		}
		
		// Para cada una de estas carteras hacemos
		for (RecobroSubCartera recobroSubCartera : recobroSubCarteras) {
			// Obtener la configuraci�n de los correctores para la subcartera -
			// Todos son de tipo ranking
			RecobroModeloFacturacion modelo;
			try {
				modelo = obtenerModeloFacturacion(recobroProcesoFacturacion.getProcesoSubcarteras(), recobroSubCartera);
			} catch (Exception e) {
				throw new Exception("Error al intentar obtener el modelo de facturacion de la subcartera: " + recobroSubCartera.getNombre() + "\n"+e.getMessage());
			}
			List<RecobroCorrectorFacturacion> recobroCorrectoresFacturacion;
			try {
				recobroCorrectoresFacturacion = modelo.getTramosCorrectores();
			} catch (Exception e) {
				throw new Exception("Error al intentar obtener los correctores para el modelo: " + modelo.getNombre() + "\n"+e.getMessage());
			}

			// Si existe alg�n tipo de corrector configurado para esa subcartera
			if (!Checks.estaVacio(recobroCorrectoresFacturacion)) {
				List<RecobroDetalleFacturacionTemporal> recobroDetallesFacturacionTemporal;
				try {
					// Obtener todos los cobros para una determinada subcartera
					recobroDetallesFacturacionTemporal = recobroDetalleFacturaTemporalManager.obtenerDetallesTemporalesFacturacionPorSubcartera(recobroSubCartera);
				} catch (Exception e) {
					throw new Exception("Error al intentar obtener los detalles de facturación de la subcartera: " + recobroSubCartera.getNombre() + "\n"+e.getMessage());
				}				
			
				List<RecobroRankingHistoricoSubcartera> recobroRankingsHistoricoSubcartera;
				try {
					// Obtener el ranking de agencias para el �ltimo d�a del periodo
					recobroRankingsHistoricoSubcartera = recobroRankingSubcarteraManager.obtenerRankingSubcarteraFecha(recobroSubCartera, recobroProcesoFacturacion.getFechaHasta());
				} catch (Exception e) {
					throw new Exception("Error al intentar obtener el ranking de las agencias de la subcarteta: " + recobroSubCartera.getNombre() + " para el día: " + recobroProcesoFacturacion.getFechaHasta().toString() + "\n"+e.getMessage());
				}				
					
					
				// Para cada uno de los cobros de la subcartera aplicar el
				// corrector definido seg�n tipo de modelo de facturaci�n y
				// subcartera
				for (RecobroDetalleFacturacionTemporal recobroDetalleFacturacionTemporal : recobroDetallesFacturacionTemporal) {
					try {
						// Obtenemos el corrector de facturaci�n para la lista de
						// correctores, la agencia del cobro y el ranking de la
						// agencia
						recobroCorrectorFacturacion = obtenerCorrectorFacturacion(recobroDetalleFacturacionTemporal.getAgencia(), recobroCorrectoresFacturacion, recobroRankingsHistoricoSubcartera);
					} catch (Exception e) {
						throw new Exception("Error al intentar obtener el corrector para la agencia: " + recobroDetalleFacturacionTemporal.getAgencia().getNombre() + "\n"+e.getMessage());
					}				
						
					
					try {
					// Creamos el objeto utilizado para persistir en la tabla
					// temporal con los correctores aplicados
						recobroDetalleFacturacionCorrectorTemporal = new RecobroDetalleFacturacionCorrectorTemporal(recobroDetalleFacturacionTemporal);
					} catch (Exception e) {
						throw new Exception("Error al intentar crear un detalle de facturación corregido.\n"+e.getMessage());
					}
					//Si obtenemos un corrector
					if (recobroCorrectorFacturacion!=null) {
						try {
							// Aplicamos el corrector al nuevo objeto que persistermos
							recobroDetalleFacturacionCorrectorTemporal.setPorcentaje(recobroDetalleFacturacionCorrectorTemporal.getPorcentaje() + recobroCorrectorFacturacion.getCoeficiente());
							recobroDetalleFacturacionCorrectorTemporal.setImporteAPagar(new Double(recobroDetalleFacturacionCorrectorTemporal.getImporteRealFacturable()
									* recobroDetalleFacturacionCorrectorTemporal.getPorcentaje() / 100));
						} catch (Exception e) {
							throw new Exception("Error al intentar aplicar el corrector.\n"+e.getMessage());
						}
						
					}
					
					try {
						// Finalmente actualizamos el detalle temporal de la factura
						// con el corrector ya aplicado
						recobroDetalleFacturaTemporalManager.insertarDetalleTemporalCorregidoFacturacion(recobroDetalleFacturacionCorrectorTemporal);
					} catch (Exception e) {
						throw new Exception("Error al intentar grabar un detalle de facturación corregido.\n"+e.getMessage());
					}
				}
			}else{
				try {
					//Como no hay correctores, movemos tal cual los detalles facturas a la tabla de corregidos
					recobroDetalleFacturaTemporalManager.moveDetallesTemporalesSinCorrectores(recobroSubCartera.getId());
				} catch (Exception e) {
					throw new Exception("Error al intentar grabar la facturación sin correctores existentes.\n"+e.getMessage());
				}
			}
		}
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void transferirDetalleFacturacionTemporalAProduccion() throws Throwable {
		//Primero borramos los detalles facturación de produccion que ya hubieran
		recobroDetalleFacturacionManager.vaciarRecobroDetalleFacturacion();
		recobroDetalleFacturaTemporalManager.transferirDetallesTemporalesFacturacionAProduccion();
	}

	/**
	 * M�todo que devuelve el corrector correspondiente a un detalle de cobro de
	 * facturaci�n, su tramo y el ranking que ten�a su correspondiente agencia.
	 * 
	 * @param recobroAgencias
	 * @param recobroCorrectoresFacturacion
	 * @param recobroRankingsHistoricoSubcartera
	 * @return
	 * @throws Throwable
	 */
	private RecobroCorrectorFacturacion obtenerCorrectorFacturacion(RecobroAgencia recobroAgencias, List<RecobroCorrectorFacturacion> recobroCorrectoresFacturacion,
			List<RecobroRankingHistoricoSubcartera> recobroRankingsHistoricoSubcartera) throws Throwable {
		RecobroCorrectorFacturacion resultado = null;
		Integer posicion = null;
		// Obtenemos el ranking de la agencia correspondiente al cobro
		for (RecobroRankingHistoricoSubcartera recobroRankingHistoricoSubcartera : recobroRankingsHistoricoSubcartera) {
			if (recobroRankingHistoricoSubcartera.getAgencia().equals(recobroAgencias)) {
				posicion = recobroRankingHistoricoSubcartera.getPosicion();
				break;
			}
		}
		// Obtenemos el corrector de facturaci�n seg�n la agencia y su ranking
		// asociado
		for (RecobroCorrectorFacturacion recobroCorrectorFacturacion : recobroCorrectoresFacturacion) {
			if (recobroCorrectorFacturacion.getRankingPosicion().equals(posicion)) {
				return recobroCorrectorFacturacion;
			}
		}

		return resultado;
	}

}
