package es.pfsgroup.plugin.liquidaciones.avanzado.manager.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.ContratoManager;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.multigestor.EXTGestorAdicionalAsuntoManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.DtoCalculoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionCabecera;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionResumen;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoTramoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQTramoPendientes;
import es.pfsgroup.plugin.liquidaciones.avanzado.manager.LiquidacionAvanzadoApi;
import es.pfsgroup.plugin.liquidaciones.avanzado.model.ActualizacionTipoCalculoLiq;
import es.pfsgroup.plugin.liquidaciones.avanzado.model.CalculoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.model.DDEstadoCalculo;
import es.pfsgroup.plugin.liquidaciones.avanzado.model.EntregaCalculoLiq;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.LIQCobroPagoDao;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoCobroPagoEntregas;
import es.pfsgroup.plugin.recovery.liquidaciones.model.LIQCobroPago;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableConceptoEntrega;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableTipoEntrega;


@Service
public class LiquidacionAvanzadoManagerImpl implements LiquidacionAvanzadoApi {
	
	@Autowired
	private EXTGestorAdicionalAsuntoManager gestorAdicionalAsuntoManager;	
	
	@Autowired
	private ProcedimientoManager procedimientoManager;
	
	@Autowired
	private ContratoManager contratoManager;
	
	@Autowired
	private LIQCobroPagoDao cobrosPagosDao;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private LIQCobroPagoDao LiqCobroPagoDao;
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.liquidaciones.avanzado.manager.impl.LiquidacionAvanzadoApi#completarCabecera(es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoReportRequest)
	 */
	@Override	
	public LIQDtoLiquidacionCabecera completarCabecera(CalculoLiquidacion request) {

		LIQDtoLiquidacionCabecera cabecera = new LIQDtoLiquidacionCabecera();

		Assertions.assertNotNull(request.getActuacion(), "plugin.liquidaciones.error.procedimiento.null");
		Assertions.assertNotNull(request.getContrato(), "plugin.liquidaciones.error.contrato.null");
		Procedimiento proc = procedimientoManager.getProcedimiento(request.getActuacion().getId());
		Contrato cont = contratoManager.get(request.getContrato().getId());
		
		Date fechaCierre = request.getFechaCierre();
		Date fechaCalculo = request.getFechaLiquidacion();
		Date fechaVencimiento = request.getContrato().getFechaVencimiento();
		
		cabecera.setFechaCalculo(fechaCalculo);
		
		cabecera.setNumCuenta(cont.getNroContratoFormat());
		cabecera.setNombre(request.getNombrePersona());
		cabecera.setDni(request.getDocumentoId());
		
		cabecera.setCapital(new BigDecimal(cont.getLimiteInicial().toString()));
		cabecera.setFechaVencimiento(fechaVencimiento);
		cabecera.setInteres(request.getInteresesOrdinarios());
		cabecera.setTipoInteres(request.getContrato().getTipoInteres());
		cabecera.setTipoIntDemora(request.getTipoMoraCierre());
		
		cabecera.setFechaCertifDeuda(fechaCierre);
		cabecera.setPrincipalCertif(request.getCapital());
		cabecera.setIntCertif(request.getInteresesOrdinarios());
		cabecera.setDemCertif(request.getInteresesDemora());
		
		if (!Checks.esNulo(proc.getTipoProcedimiento())) {
			cabecera.setTipoProc(proc.getTipoProcedimiento().getDescripcion());
		}
		cabecera.setAutos(proc.getCodigoProcedimientoEnJuzgado());
		if (!Checks.esNulo(proc.getJuzgado())) {
			cabecera.setJuzgado(proc.getJuzgado().getDescripcion());
		}
		
		if (!Checks.esNulo(proc.getAsunto())) {
			Usuario letrado = gestorAdicionalAsuntoManager.obtenerLetradoDelAsunto(proc.getAsunto().getId());
			if (!Checks.esNulo(letrado)) {
				cabecera.setAbogado(letrado.getApellidoNombre());
			}
			
			if (!Checks.esNulo(proc.getAsunto().getProcurador())
					&& !Checks.esNulo(proc.getAsunto().getProcurador().getUsuario())) {
				cabecera.setProcurador(proc.getAsunto().getProcurador().getUsuario().getApellidoNombre());
			}
		}
		
		return cabecera;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.liquidaciones.avanzado.manager.impl.LiquidacionAvanzadoApi#obtenerLiquidaciones(es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoReportRequest, es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQTramoPendientes)
	 */
	@Override
	public List<LIQDtoTramoLiquidacion> obtenerLiquidaciones(CalculoLiquidacion request, LIQTramoPendientes pendientes) {
		List<LIQDtoTramoLiquidacion> cuerpo = new ArrayList<LIQDtoTramoLiquidacion>();
		
		Date fechaCierre = request.getFechaCierre();
		Date fechaCalculo = request.getFechaLiquidacion();
		
		//1.- Tramo inicial
		Date fecha = fechaCierre;
		Float tipoInt = request.getTipoMoraCierre();
		
		LIQDtoTramoLiquidacion tramoInicial = new LIQDtoTramoLiquidacion();
		tramoInicial.setFechaValor(DateFormat.toString(fecha));
		tramoInicial.setDescripcion("Principal reclamado");
		tramoInicial.setSaldo(pendientes.getSaldo());
		tramoInicial.setIntDemoraCierrePend(pendientes.getIntDemoraCierre());
		tramoInicial.setInteresesPendientes(pendientes.getIntereses());
		cuerpo.add(tramoInicial);
		
		//2. - Ahora van los diferentes tramos, que son las entregas a cuenta y los cambios de tipo de interés
		//List<LIQCobroPago> entregasCuenta = cobrosPagosDao.findEntregasACuenta(request.getContrato(), fechaCierre, fechaCalculo);
		List<EntregaCalculoLiq> entregasCuenta = this.getEntregasCalculo(request.getId());
		
		for (EntregaCalculoLiq ec : entregasCuenta) {
			//Agregamos los cambios de tipos intermedios y se actualiza el tipo de interes
			tipoInt = this.AgregarcambiosTipoEntreFechas(request, fecha, ec.getFechaValor(), pendientes.getSaldo(), pendientes.getIntDemoraCierre(), pendientes.getIntereses(), cuerpo, tipoInt);
			//Actualizar pendiente arrastrado de la demora pendiente cobro
			//Actualizmos la fecha
			if (cuerpo.size()>0) {
				LIQDtoTramoLiquidacion tramoInsertado = cuerpo.get(cuerpo.size()-1);
				pendientes.setIntDemoraCierre(tramoInsertado.getIntDemoraCierrePend());
				try {
					fecha = DateFormat.toDate(tramoInsertado.getFechaValor());
				} catch (Exception e) {};
			}
			
			//Ahora creamos el tramo para la entrega cuenta
			LIQDtoTramoLiquidacion tramo = generarTramoParaEntrega(ec, fecha, tipoInt, request.getBaseCalculo(), pendientes);
			
			// Y lo agregamos al cuerpo
			cuerpo.add(tramo);
			
			//Avanzamos fecha
			fecha = ec.getFechaValor();
		}
		
		//Ahora insertamos los cambios de tipo entre la ultima entrega y la fecha de calculo
		//Actualizar pendiente arrastrado de la demora pendiente cobro
		tipoInt = this.AgregarcambiosTipoEntreFechas(request, fecha, fechaCalculo, pendientes.getSaldo(), pendientes.getIntDemoraCierre(), pendientes.getIntereses(), cuerpo, tipoInt);
		//Actualizmos la fecha
		if (cuerpo.size()>0) {
			LIQDtoTramoLiquidacion tramoInsertado = cuerpo.get(cuerpo.size()-1);
			pendientes.setIntDemoraCierre(tramoInsertado.getIntDemoraCierrePend());
			try {
				fecha = DateFormat.toDate(tramoInsertado.getFechaValor());
			} catch (Exception e) {};
		}

		
		//3.- Por último el tramo del Calculo de Deuda, desde la última fecha hasta la fecha Calculo
		LIQDtoTramoLiquidacion ultTramo = new LIQDtoTramoLiquidacion();
		
		ultTramo.setDias(diferenciaDias(fecha, fechaCalculo));
		//El cierre incluye también el último día
		ultTramo.setDias(ultTramo.getDias()+1);
		ultTramo.setTipoDemora(tipoInt);
		ultTramo.setInteresesDemora(calcularInteresesDemora(pendientes.getSaldo(), ultTramo.getDias(), tipoInt, request.getBaseCalculo()));
		
		ultTramo.setFechaValor(DateFormat.toString(request.getFechaLiquidacion()));
		ultTramo.setDescripcion("C\u00E1lculo deuda");
		ultTramo.setSaldo(pendientes.getSaldo());
		ultTramo.setIntDemoraCierrePend(pendientes.getIntDemoraCierre().add(ultTramo.getInteresesDemora()));
		ultTramo.setInteresesPendientes(pendientes.getIntereses());

		ultTramo.setImpuestosPendientes(pendientes.getImpuestos());
		ultTramo.setComisionesPendientes(pendientes.getComisiones());
		ultTramo.setGastosPendientes(pendientes.getGastos());
		ultTramo.setCostasLetradoPendientes(pendientes.getCostasLetrado());
		ultTramo.setCostasProcuradorPendientes(pendientes.getCostasProcurador());
		

		
		cuerpo.add(ultTramo);
		
		return cuerpo;
	}
	
	private LIQDtoTramoLiquidacion generarTramoParaEntrega(EntregaCalculoLiq ec, Date fechaAnt, Float tipoInt, int baseCalculo, LIQTramoPendientes pendientes) {
		
		//Boolean entregaDesglosada = new Boolean(usuarioManager.getUsuarioLogado().getEntidad().configValue("CobrosDesglosados", "false"));
		LIQDtoTramoLiquidacion tramo = new LIQDtoTramoLiquidacion();

		/*if (entregaDesglosada) {
			tramo = tramoEntregaDesglosada(ec, fechaAnt, tipoInt, baseCalculo, pendientes);
		} else {*/
			tramo = tramoEntregaNoDesglosada(ec, fechaAnt, tipoInt, baseCalculo, pendientes);
		//}
		
		//Datos iguales de metodo desglosado o no
		tramo.setFechaValor(DateFormat.toString(ec.getFechaValor()));
		tramo.setDescripcion("Entrega");
		if (!Checks.esNulo(ec.getSumaEntrega())) {
			tramo.setImporte(ec.getSumaEntrega());
		}
		tramo.setIntDemoraCierrePend(pendientes.getIntDemoraCierre());
		tramo.setInteresesPendientes(pendientes.getIntereses());
		tramo.setImpuestosPendientes(pendientes.getImpuestos());
		tramo.setComisionesPendientes(pendientes.getComisiones());
		tramo.setGastosPendientes(pendientes.getGastos());
		tramo.setCostasLetradoPendientes(pendientes.getCostasLetrado());
		tramo.setCostasProcuradorPendientes(pendientes.getCostasProcurador());
		tramo.setTipoDemora(tipoInt);
		
		return tramo;
	}
	
	/*
	private LIQDtoTramoLiquidacion tramoEntregaDesglosada(LIQCobroPago ec, Date fechaAnt, Float tipoInt, int baseCalculo, LIQTramoPendientes pendientes) {
		LIQDtoTramoLiquidacion tramo = new LIQDtoTramoLiquidacion();
		
		if (!Checks.esNulo(ec.getCapital()) || !Checks.esNulo(ec.getCapitalNoVencido())) {
			BigDecimal entregado = BigDecimal.ZERO;
			entregado = entregado.add(ec.getCapital()!=null?new BigDecimal(ec.getCapital().toString()):BigDecimal.ZERO);
			entregado = entregado.add(ec.getCapitalNoVencido()!=null?new BigDecimal(ec.getCapitalNoVencido().toString()):BigDecimal.ZERO);
			
			tramo.setEntregado(entregado);
		}
		if (!Checks.esNulo(ec.getInteresesOrdinarios())) {
			pendientes.setIntereses(pendientes.getIntereses().subtract(new BigDecimal(ec.getInteresesOrdinarios().toString())));
			tramo.setIntereses(new BigDecimal(ec.getInteresesOrdinarios().toString()));
		}
		if (!Checks.esNulo(ec.getImpuestos())) {
			pendientes.setImpuestos(pendientes.getImpuestos().subtract(new BigDecimal(ec.getImpuestos().toString())));
			tramo.setImpuestos(new BigDecimal(ec.getImpuestos().toString()));
		}
		if (!Checks.esNulo(ec.getComisiones())) {
			pendientes.setComisiones(pendientes.getComisiones().subtract(new BigDecimal(ec.getComisiones().toString())));
			tramo.setComisiones(new BigDecimal(ec.getComisiones().toString()));
		}
		if (!Checks.esNulo(ec.getGastosOtros())) {
			pendientes.setGastos(pendientes.getGastos().subtract(new BigDecimal(ec.getGastosOtros().toString())));
			tramo.setGastos(new BigDecimal(ec.getGastosOtros().toString()));
		}
		if (!Checks.esNulo(ec.getGastosAbogado())) {
			pendientes.setCostasLetrado(pendientes.getCostasLetrado().subtract(new BigDecimal(ec.getGastosAbogado().toString())));
			tramo.setCostasLetrado(new BigDecimal(ec.getGastosAbogado().toString()));
		}
		if (!Checks.esNulo(ec.getGastosProcurador())) {
			pendientes.setCostasProcurador(pendientes.getCostasProcurador().subtract(new BigDecimal(ec.getGastosProcurador().toString())));
			tramo.setCostasProcurador(new BigDecimal(ec.getGastosProcurador().toString()));
		}
		
		tramo.setDias(diferenciaDias(fechaAnt, ec.getFechaValor()));
		tramo.setInteresesDemora(calcularInteresesDemora(pendientes.getSaldo(), tramo.getDias(), tipoInt, baseCalculo));
		
		//Restar la parte de saldo
		if (!Checks.esNulo(ec.getCapital())) {
			pendientes.setSaldo(pendientes.getSaldo().subtract(new BigDecimal(ec.getCapital().toString())));
		}
		tramo.setSaldo(pendientes.getSaldo());
		
		return tramo;
	}
	*/
	
	private LIQDtoTramoLiquidacion tramoEntregaNoDesglosada(EntregaCalculoLiq ec, Date fechaAnt, Float tipoInt, int baseCalculo, LIQTramoPendientes pendientes) {
		LIQDtoTramoLiquidacion tramo = new LIQDtoTramoLiquidacion();
		
		BigDecimal importeECRestante = (!Checks.esNulo(ec.getTotalEntrega())?ec.getTotalEntrega():BigDecimal.ZERO);
		
		//1º Cáculo de días
		tramo.setDias(diferenciaDias(fechaAnt, ec.getFechaValor()));
		
		
		//2º Cáculo interés demora
		tramo.setInteresesDemora(calcularInteresesDemora(pendientes.getSaldo(), tramo.getDias(), tipoInt, baseCalculo));		
		
		//3º Descontar de la entrega (los intereses de demora + la demora pendiente
		BigDecimal demoraPendiente = pendientes.getIntDemoraCierre().add(tramo.getInteresesDemora());
		
		
		//De la entrega primero reducimos de los intereses demora cierre pendientes
		if (importeECRestante.compareTo(demoraPendiente) == 1) {
			//Si la entrega es superior a los intereses demora cierre
			tramo.setIntDemoraCierre(demoraPendiente);
			importeECRestante = importeECRestante.subtract(tramo.getIntDemoraCierre());
			pendientes.setIntDemoraCierre(BigDecimal.ZERO);
		} else {
			//Reducimos parte de los intereses demora cierre
			tramo.setIntDemoraCierre(importeECRestante);
			pendientes.setIntDemoraCierre(demoraPendiente.subtract(importeECRestante));
			importeECRestante = BigDecimal.ZERO;
		}
		
		
		//4º Descontamos intereses
		
		//Si todavia nos queda importe de la entrega
		if (importeECRestante.compareTo(BigDecimal.ZERO) == 1) {
			//Reducimos de los intereses pendientes
			if (pendientes.getIntereses().compareTo(BigDecimal.ZERO) == 1) {
				//Si la entrega es superior a los intereses
				if (importeECRestante.compareTo(pendientes.getIntereses()) == 1) {
					//Nos quedamos sin intereses
					tramo.setIntereses(pendientes.getIntereses());
					importeECRestante = importeECRestante.subtract(tramo.getIntereses());
					pendientes.setIntereses(BigDecimal.ZERO);
				} else {
					//Reducimos parte de los intereses y nos quedamos sin importe en la entrega
					tramo.setIntereses(importeECRestante);
					pendientes.setIntereses(pendientes.getIntereses().subtract(importeECRestante));
					importeECRestante = BigDecimal.ZERO;
				}
			}
		}
		
		//5º Descontamos capital
		
		//Si todavia nos queda importe de la entrega
		if (importeECRestante.compareTo(BigDecimal.ZERO) == 1) {
			//De la entrega segundo reducimos capital
			if (importeECRestante.compareTo(pendientes.getSaldo()) == 1) {
				//Nos quedamos sin capital
				tramo.setEntregado(pendientes.getSaldo());
				importeECRestante = importeECRestante.subtract(tramo.getEntregado());
				pendientes.setSaldo(BigDecimal.ZERO);
				//tramo.setSaldo(pendientes.getSaldo());
			} else {
				//Reducimos parte del capital y nos quedamos sin importe en la entrega
				tramo.setEntregado(importeECRestante);
				pendientes.setSaldo(pendientes.getSaldo().subtract(importeECRestante));
				//tramo.setSaldo(pendientes.getSaldo());
				importeECRestante = BigDecimal.ZERO;
			}
		}
		
		tramo.setSaldo(pendientes.getSaldo());
		
		//Si todavia nos queda importe de la entrega
		if (importeECRestante.compareTo(BigDecimal.ZERO) == 1) {
			//Nos quedamos el restante para luego restarlo de los intereses demora calculados
			pendientes.setSobranteEntrega(pendientes.getSobranteEntrega().add(importeECRestante));
		}
		
		//Gastos
		if (!Checks.esNulo(ec.getOtrosGastos())) {
			pendientes.setGastos(pendientes.getGastos().subtract(ec.getOtrosGastos()));
			tramo.setGastos(ec.getOtrosGastos());
		}
		if (!Checks.esNulo(ec.getGastosLetrado())) {
			pendientes.setCostasLetrado(pendientes.getCostasLetrado().subtract(ec.getGastosLetrado()));
			tramo.setCostasLetrado(ec.getGastosLetrado());
		}
		if (!Checks.esNulo(ec.getGastosProcurador())) {
			pendientes.setCostasProcurador(pendientes.getCostasProcurador().subtract(ec.getGastosProcurador()));
			tramo.setCostasProcurador(ec.getGastosProcurador());
		}
		
		
		return tramo;
	}
	
	
	
	private int diferenciaDias(Date fechaInicio, Date fechaFin) {
		Calendar calInicio = Calendar.getInstance();
		calInicio.setTime(fechaInicio);
		
		Calendar calFin = Calendar.getInstance();
		calFin.setTime(fechaFin);
		
		/*long diffMili = calFin.getTimeInMillis() - calInicio.getTimeInMillis();
		
		return (int) (diffMili / (24 * 60 * 60 * 1000));*/
		
		int dias = 0;
		while (calInicio.before(calFin)) {
			dias++;
			calInicio.add(Calendar.DATE, 1);
		}
		
		return dias;
	}
	
	private BigDecimal calcularInteresesDemora(BigDecimal saldo, int dias, Float tipoDemora, int baseCalculo) {
		BigDecimal resultado = saldo.multiply(new BigDecimal(dias));
		resultado = resultado.multiply(new BigDecimal(tipoDemora.toString()));
		resultado = resultado.divide(new BigDecimal(baseCalculo * 100), 2, RoundingMode.HALF_UP);
		
		return resultado;
	}
	
	private Float AgregarcambiosTipoEntreFechas(CalculoLiquidacion request, Date fechaDesde, Date fechaHasta, BigDecimal saldo, BigDecimal demora, BigDecimal intereses, List<LIQDtoTramoLiquidacion> cuerpo, Float tipoInt) {
		Calendar c = Calendar.getInstance();
		Date fecha = fechaDesde;
		Date fechaAnt = fechaDesde;
		Float tipo = tipoInt; 
		
		//Mientras tengamos cambios de interes entre la fecha y la entregaCuenta
		ActualizacionTipoCalculoLiq cambioTipoInteres;
		do {
			cambioTipoInteres = this.getPrimerCambioEntreFechas(fecha, fechaHasta, request.getActualizacionesTipo());
			if (cambioTipoInteres!=null) {
				Date fechaCambio =  cambioTipoInteres.getFecha();
				//Creamos una línea de tipo de Cambio de Tipo de Interes
				
				LIQDtoTramoLiquidacion tramoCambioTipo = new LIQDtoTramoLiquidacion();
				tramoCambioTipo.setFechaValor(DateFormat.toString(fechaCambio));
				tramoCambioTipo.setDescripcion("Cambio inter\u00E9s de demora");
				tramoCambioTipo.setSaldo(saldo);

				tramoCambioTipo.setInteresesPendientes(intereses);
				tramoCambioTipo.setDias(diferenciaDias(fechaAnt, fechaCambio));
				tramoCambioTipo.setTipoDemora(tipo);
				tramoCambioTipo.setInteresesDemora(calcularInteresesDemora(saldo, tramoCambioTipo.getDias(),tipo, request.getBaseCalculo()));
				
				tramoCambioTipo.setIntDemoraCierrePend(demora.add(tramoCambioTipo.getInteresesDemora()));
				demora = tramoCambioTipo.getIntDemoraCierrePend();
				
				//Avanzamos la fecha y actualizamos el tipoInt
				fechaAnt = fechaCambio;
				//Avanzamos un día
				c.setTime(fechaCambio); 
				c.add(Calendar.DATE, 1);
				fecha = c.getTime();				
				tipo = cambioTipoInteres.getTipoInteres();
				
				cuerpo.add(tramoCambioTipo);
			}
		} while (cambioTipoInteres !=null);		
		
		//Devolvemos el tipo actualizado
		return tipo;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.liquidaciones.avanzado.manager.impl.LiquidacionAvanzadoApi#crearResumen(es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoReportRequest, java.util.List, es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQTramoPendientes)
	 */
	@Override
	public LIQDtoLiquidacionResumen crearResumen(CalculoLiquidacion request, List<LIQDtoTramoLiquidacion> cuerpo, LIQTramoPendientes pendientes) {
		LIQDtoLiquidacionResumen resumen = new LIQDtoLiquidacionResumen();
		LIQDtoTramoLiquidacion ultTramo = null;
		
		if (cuerpo.size()>0) {
			ultTramo = cuerpo.get(cuerpo.size()-1);
		}
		
		//Total Deuda
		BigDecimal totalDeuda = BigDecimal.ZERO;
		if (ultTramo!= null) {
			//Cogemos el último saldo
			totalDeuda = totalDeuda.add(ultTramo.getSaldo());
			//Y le sumamos los intereses demora al cierre por pagar
			totalDeuda = totalDeuda.add(ultTramo.getIntDemoraCierrePend());
			//Y le sumamos los intereses pendientes por pagar
			totalDeuda = totalDeuda.add(ultTramo.getInteresesPendientes());
			/*
			// Y le sumamos todos los intereses demora calculados
			for (LIQDtoTramoLiquidacion tramo : cuerpo) {
				if (tramo.getInteresesDemora()!=null) {
					totalDeuda = totalDeuda.add(tramo.getInteresesDemora());
				}
			}
			*/
		}
		resumen.setTotalDeuda(totalDeuda);
		
		//Impuestos
		BigDecimal impuestos = BigDecimal.ZERO;
		if (ultTramo != null && ultTramo.getImpuestosPendientes()!=null) {
			impuestos = ultTramo.getImpuestosPendientes();
		}
		resumen.setImpuestos(impuestos);
		
		//Comisiones
		BigDecimal comisiones = BigDecimal.ZERO;
		if (ultTramo != null && ultTramo.getComisionesPendientes()!=null) {
			comisiones = ultTramo.getComisionesPendientes();
		}
		resumen.setComisiones(comisiones);
		
		//Costas letrado
		BigDecimal costasLetrado = BigDecimal.ZERO;
		if (ultTramo != null && ultTramo.getCostasLetradoPendientes()!=null) {
			costasLetrado = ultTramo.getCostasLetradoPendientes();
		}
		resumen.setCostasLetrado(costasLetrado);
		
		
		//Costas procurador
		BigDecimal costasProcurador = BigDecimal.ZERO;
		if (ultTramo != null && ultTramo.getCostasProcuradorPendientes()!=null) {
			costasProcurador = ultTramo.getCostasProcuradorPendientes();
		}
		resumen.setCostasProcurador(costasProcurador);
		
		//Otros gastos
		BigDecimal gastos = BigDecimal.ZERO;
		if (ultTramo!=null && ultTramo.getGastosPendientes()!=null) {
			gastos = ultTramo.getGastosPendientes();
		}
		resumen.setOtrosGastos(gastos);
		
		resumen.setEntregadoIntDemoraCalc(pendientes.getSobranteEntrega());
		resumen.setTotalDeudaReal(resumen.getTotalDeuda().subtract(pendientes.getSobranteEntrega()));		
		
		//Total a pagar
		BigDecimal totalPagar = BigDecimal.ZERO;
		totalPagar = totalPagar.subtract(pendientes.getSobranteEntrega());
		totalPagar = totalPagar.add(totalDeuda);
		totalPagar = totalPagar.add(impuestos);
		totalPagar = totalPagar.add(comisiones);
		totalPagar = totalPagar.add(costasLetrado);
		totalPagar = totalPagar.add(costasProcurador);
		totalPagar = totalPagar.add(gastos);
		
		resumen.setTotalPagar(totalPagar);
		
		return resumen;
	}

	@Override
	public CalculoLiquidacion convertDtoCalculoLiquidacionTOCalculoLiquidacion(DtoCalculoLiquidacion dto) {
		
		CalculoLiquidacion calcLiq = new CalculoLiquidacion();
		
		if(!Checks.esNulo(dto)){
			
			if(!Checks.esNulo(dto.getId())){
				Filter filter = genericDao.createFilter(FilterType.EQUALS,"id", dto.getId());
				calcLiq = genericDao.get(CalculoLiquidacion.class, filter);
			}
			
		}

		calcLiq.setNombre(dto.getNombre());
		calcLiq.setNombrePersona(dto.getNombrePersona());
		calcLiq.setDocumentoId(dto.getDocumentoId());
		calcLiq.setCapital(dto.getCapital());
		calcLiq.setInteresesOrdinarios(dto.getInteresesOrdinarios());
		calcLiq.setInteresesDemora(dto.getInteresesDemora());
		calcLiq.setComisiones(dto.getComisiones());
		calcLiq.setImpuestos(dto.getImpuestos());
		calcLiq.setGastos(dto.getGastos());
		calcLiq.setCostasLetrado(dto.getCostasLetrado());
		calcLiq.setCostasProcurador(dto.getCostasProcurador());
		calcLiq.setOtrosGastos(dto.getOtrosGastos());
		calcLiq.setBaseCalculo(dto.getBaseCalculo());
		calcLiq.setTipoMoraCierre(dto.getTipoMoraCierre());
		calcLiq.setTotalCaculo(dto.getTotalCaculo());
		
		
		SimpleDateFormat frmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		
		try {
			calcLiq.setFechaCierre(frmt.parse(dto.getFechaCierre()));
			calcLiq.setFechaLiquidacion(frmt.parse(dto.getFechaLiquidacion()));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		
		if(!Checks.esNulo(dto.getAsunto())){
			Filter filter = genericDao.createFilter(FilterType.EQUALS,"id", dto.getAsunto());
			EXTAsunto asunto = genericDao.get(EXTAsunto.class, filter);
			calcLiq.setAsunto(asunto);
		}
		
		if(!Checks.esNulo(dto.getActuacion())){
			Filter filter = genericDao.createFilter(FilterType.EQUALS,"id", dto.getActuacion());
			MEJProcedimiento actuacion = genericDao.get(MEJProcedimiento.class, filter);
			calcLiq.setActuacion(actuacion);
		}
		
		if(!Checks.esNulo(dto.getContrato())){
			Filter filter = genericDao.createFilter(FilterType.EQUALS,"id", dto.getContrato());
			EXTContrato contrato = genericDao.get(EXTContrato.class, filter);
			calcLiq.setContrato(contrato);
		}
		
		if(!Checks.esNulo(dto.getEstadoCalculo())){
			Filter filter = genericDao.createFilter(FilterType.EQUALS,"codigo", dto.getEstadoCalculo());
			DDEstadoCalculo estadoCalculo = genericDao.get(DDEstadoCalculo.class, filter);
			calcLiq.setEstadoCalculo(estadoCalculo);
		}

		return calcLiq;
	}
	
	@Override
	public CalculoLiquidacion getCalculoById(Long calculoId)  {
		CalculoLiquidacion calculo = genericDao.get(CalculoLiquidacion.class, genericDao.createFilter(FilterType.EQUALS, "id", calculoId));
		
		return calculo;
	}
	
	@Override
	public List<CalculoLiquidacion> obtenerCalculosLiquidacionesAsunto(Long idAsunto)  {
		Order orden = new Order(OrderType.ASC, "id");
		List<CalculoLiquidacion> listaCalculos = genericDao.getListOrdered(CalculoLiquidacion.class, orden, genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto));
		return listaCalculos;
	}
	
	@Override
	public List<EntregaCalculoLiq> getEntregasCalculo(Long idCalculo) {

		Order orden = new Order(OrderType.ASC, "id");
		List<EntregaCalculoLiq> listaEntregas = genericDao.getListOrdered(EntregaCalculoLiq.class, orden, genericDao.createFilter(FilterType.EQUALS, "calculoLiquidacion.id", idCalculo), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));

		return listaEntregas;
	}
	
	/**
	 * Encuentra el primer cambio de tipo de interes entre las fechas
	 * @param desde
	 * @param hasta
	 * @param lTiposInteres Lista con los cambios de tipo de interes
	 * @return un cambio encontrado o null
	 */
	private ActualizacionTipoCalculoLiq getPrimerCambioEntreFechas(Date desde, Date hasta, List<ActualizacionTipoCalculoLiq> lTiposInteres) {
		Calendar c = Calendar.getInstance();
		
		Date fecha = this.NormalizarFechas(desde);
		while (fecha.compareTo(hasta)<=0) {
			for (ActualizacionTipoCalculoLiq tipo : lTiposInteres) {
				if (fecha.compareTo(this.NormalizarFechas(tipo.getFecha()))==0) {
					return tipo;
				}
			}

			//Avanzamos un día
			c.setTime(fecha); 
			c.add(Calendar.DATE, 1);
			fecha = c.getTime();
		}
		
		return null;
	}
	
	private Date NormalizarFechas(Date fecha) {
		Calendar c = Calendar.getInstance();
		c.setTime(fecha);
		
		c.set(Calendar.HOUR_OF_DAY, 0);
		c.set(Calendar.MINUTE, 0);
		c.set(Calendar.SECOND, 0);
		c.set(Calendar.MILLISECOND, 0);
		
		return c.getTime();
	}

	
	@SuppressWarnings("null")
	@Transactional(readOnly = false)
	@Override
	public void createOrUpdateEntCalLiquidacion(LIQDtoCobroPagoEntregas dto){
		
		Long idCalculo= dto.getIdCalculo();
		String tipoEntrega= dto.getTipoEntrega();//Codigo CAN
		String conceptoEntrega= dto.getConceptoEntrega();//Concepto Entrega
		String fechaEntrega= dto.getFechaEntrega();
		String fechaValor= dto.getFechaValor();
		BigDecimal gastosProcurador = null;
		BigDecimal gastosAbogado = null;
		BigDecimal gastosOtros = null;
		BigDecimal totalEntrega = null;

		

		
		if(dto.getGastosAbogado()!=null){
			gastosAbogado = new BigDecimal(dto.getGastosAbogado());
		}
		if(dto.getGastosProcurador()!=null){
			gastosProcurador = new BigDecimal(dto.getGastosProcurador());
		}
		if(dto.getOtrosGastos()!=null){
			gastosOtros = new BigDecimal(dto.getOtrosGastos());
		}
		if(dto.getTotalEntrega()!=null){
			totalEntrega = new BigDecimal(dto.getTotalEntrega());
		}

		
		EntregaCalculoLiq entregasCalculo= new EntregaCalculoLiq();
		
		if(dto.getId() != null){
			entregasCalculo=  genericDao.get(EntregaCalculoLiq.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));
		}
		else{
//			entregasCalculo= getInstance(idAsunto);
		}
		
		if(idCalculo != null){
			CalculoLiquidacion calliq = genericDao.get(CalculoLiquidacion.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),genericDao.createFilter(FilterType.EQUALS, "id", idCalculo));
			Assertions.assertNotNull(idCalculo, "No existe");
			entregasCalculo.setCalculoLiquidacion(calliq);
		}
	
		if(fechaEntrega != null && fechaEntrega != ""){
			try {
				java.sql.Date sqlFE = new java.sql.Date(DateFormat.toDate(dto.getFechaEntrega()).getTime());
				entregasCalculo.setFechaEntrega(sqlFE);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			Assertions.assertNotNull(fechaEntrega, "Fecha no valida");
		}
		
		if(fechaValor != null && fechaValor != ""){
			try {
				java.sql.Date sqlFV = new java.sql.Date(DateFormat.toDate(dto.getFechaValor()).getTime());
				entregasCalculo.setFechaValor(sqlFV);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			Assertions.assertNotNull(fechaValor, "Fecha no valida");

		}
		
		if(tipoEntrega != null && tipoEntrega!= ""){
			DDAdjContableTipoEntrega ddTipoEntrega = genericDao.get(DDAdjContableTipoEntrega.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),genericDao.createFilter(FilterType.EQUALS, "codigo", tipoEntrega));
			Assertions.assertNotNull(ddTipoEntrega, "Tipo no valido");
			entregasCalculo.setTipoEntrega(ddTipoEntrega);
		}
		
		if(conceptoEntrega != null && conceptoEntrega!= ""){
			DDAdjContableConceptoEntrega ddConceptoEntrega = genericDao.get(DDAdjContableConceptoEntrega.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),genericDao.createFilter(FilterType.EQUALS, "codigo", conceptoEntrega));
			Assertions.assertNotNull(ddConceptoEntrega, "Concepto no valido");
			entregasCalculo.setConceptoEntrega(ddConceptoEntrega);
		}
		
		
		entregasCalculo.setGastosProcurador(gastosProcurador);
		entregasCalculo.setGastosLetrado(gastosAbogado);
		entregasCalculo.setOtrosGastos(gastosOtros);
		entregasCalculo.setTotalEntrega(totalEntrega);
		
		
		genericDao.save(EntregaCalculoLiq.class, entregasCalculo);
		
		
		
		
	}

	@Transactional(readOnly = false)
	@Override
	public CalculoLiquidacion saveCalculoLiquidacionAvanzado(CalculoLiquidacion cl) {
		Auditoria auditoria = Auditoria.getNewInstance();
		cl.setAuditoria(auditoria);
		genericDao.save(CalculoLiquidacion.class, cl);
		return cl;
	}

	@Transactional(readOnly = false)
	@Override
	public void creaTiposInteresParaCalculoLiquidacion(List<String> tiposInteres, CalculoLiquidacion calculoLiquidacion) {
		
		SimpleDateFormat frmt = new SimpleDateFormat("dd/MM/yyyy");
		
		for(String tipo : tiposInteres){
			
			if(!tipo.equals("") && tipo.contains("#")){
				String fecha = tipo.split("#")[0];
				String tipoInteres = tipo.split("#")[1]; 
				Auditoria auditoria = Auditoria.getNewInstance();
				
				ActualizacionTipoCalculoLiq actTipCalc = new ActualizacionTipoCalculoLiq();
				
				actTipCalc.setCalculoLiquidacion(calculoLiquidacion);
				actTipCalc.setTipoInteres(Float.parseFloat(tipoInteres));
				actTipCalc.setAuditoria(auditoria);
				
				try {
					actTipCalc.setFecha(frmt.parse(fecha));
				} catch (ParseException e) {
					e.printStackTrace();
				}
				
				genericDao.save(ActualizacionTipoCalculoLiq.class, actTipCalc);
			}
		}
		
	}

	@Override
	public CalculoLiquidacion getCalculoLiquidacion(Long idCalcLiq) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS,"id", idCalcLiq);
		return genericDao.get(CalculoLiquidacion.class, filter);
	}

	@Override
	public DtoCalculoLiquidacion convertCalculoLiquidacionTODtoCalculoLiquidacion(CalculoLiquidacion calcLiq) {
		
		SimpleDateFormat frmt = new SimpleDateFormat("dd/MM/yyyy");
		
		DtoCalculoLiquidacion dto = new DtoCalculoLiquidacion();
		
		dto.setId(calcLiq.getId());
		dto.setNombre(calcLiq.getNombre());
		dto.setNombrePersona(calcLiq.getNombrePersona());
		dto.setDocumentoId(calcLiq.getDocumentoId());
		dto.setCapital(calcLiq.getCapital());
		dto.setInteresesOrdinarios(calcLiq.getInteresesOrdinarios());
		dto.setInteresesDemora(calcLiq.getInteresesDemora());
		dto.setComisiones(calcLiq.getComisiones());
		dto.setImpuestos(calcLiq.getImpuestos());
		dto.setGastos(calcLiq.getGastos());
		dto.setCostasLetrado(calcLiq.getCostasLetrado());
		dto.setCostasProcurador(calcLiq.getCostasProcurador());
		dto.setOtrosGastos(calcLiq.getOtrosGastos());
		dto.setBaseCalculo(calcLiq.getBaseCalculo());
		dto.setTipoMoraCierre(calcLiq.getTipoMoraCierre());
		dto.setTotalCaculo(calcLiq.getTotalCaculo());
		dto.setFechaCierre(frmt.format(calcLiq.getFechaCierre()));
		dto.setFechaLiquidacion(frmt.format(calcLiq.getFechaLiquidacion()));
		if(!Checks.esNulo(calcLiq.getAsunto())) dto.setAsunto(calcLiq.getAsunto().getId());
		if(!Checks.esNulo(calcLiq.getActuacion())) dto.setActuacion(calcLiq.getActuacion().getId());
		if(!Checks.esNulo(calcLiq.getContrato())) dto.setContrato(calcLiq.getContrato().getId());
		if(!Checks.esNulo(calcLiq.getEstadoCalculo())) dto.setEstadoCalculo(calcLiq.getEstadoCalculo().getCodigo());
		
		List<String> actualizaciones = new ArrayList<String>();
		for(ActualizacionTipoCalculoLiq acTipCalLiq : calcLiq.getActualizacionesTipo()){
			actualizaciones.add(acTipCalLiq.getFecha().toString()+"#"+acTipCalLiq.getTipoInteres().toString());
		}
		
		if(!Checks.estaVacio(actualizaciones)){
			dto.setTiposIntereses(actualizaciones);
		}
		
		return dto;
	}
	
	@Transactional(readOnly = false)
	@Override
	public void eliminarEntregaCalLiquidacion(Long idEntrega){
		genericDao.deleteById(EntregaCalculoLiq.class, idEntrega);
	}
	
	@Transactional(readOnly = false)
	@Override
	public CalculoLiquidacion updateCalculoLiquidacionAvanzado(CalculoLiquidacion cl) {
		genericDao.update(CalculoLiquidacion.class, cl);
		return cl;
	}
	
	@Transactional(readOnly = false)
	@Override
	public void updateTiposInteresParaCalculoLiquidacion(List<String> tiposInteres, CalculoLiquidacion calculoLiquidacion) {
		
		for(ActualizacionTipoCalculoLiq actTipCal : calculoLiquidacion.getActualizacionesTipo()){
			genericDao.deleteById(ActualizacionTipoCalculoLiq.class, actTipCal.getId());
		}
		
		creaTiposInteresParaCalculoLiquidacion(tiposInteres, calculoLiquidacion);
		
	}
	
	@Transactional(readOnly = false)
	@Override
	public void createEntCalLicFomCobrosPago(CalculoLiquidacion calcLiq, Long contratoId, Date fechaCierre, Date fechaLiquidacion){
		List<LIQCobroPago> cobrosPago =  LiqCobroPagoDao.findEntregasACuenta(contratoId, fechaCierre, fechaLiquidacion);
		
		for(LIQCobroPago cobro : cobrosPago){
			
			EntregaCalculoLiq entCal = new EntregaCalculoLiq();
			
			entCal.setCalculoLiquidacion(calcLiq);
			entCal.setFechaEntrega(cobro.getFecha());
			entCal.setFechaValor(cobro.getFechaValor());
			entCal.setTipoEntrega(cobro.getTipoEntrega());
			entCal.setConceptoEntrega(cobro.getConceptoEntrega());
			if(!Checks.esNulo(cobro.getImporte())) entCal.setTotalEntrega(BigDecimal.valueOf(cobro.getImporte()));
			if(!Checks.esNulo(cobro.getGastosProcurador())) entCal.setGastosProcurador(BigDecimal.valueOf(cobro.getGastosProcurador()));
			if(!Checks.esNulo(cobro.getGastosAbogado())) entCal.setGastosLetrado(BigDecimal.valueOf(cobro.getGastosAbogado()));
			if(!Checks.esNulo(cobro.getGastosOtros())) entCal.setOtrosGastos(BigDecimal.valueOf(cobro.getGastosOtros()));
			entCal.setAuditoria(Auditoria.getNewInstance());
			try{
				genericDao.save(EntregaCalculoLiq.class, entCal);	
			}catch(Exception e){
				System.out.println(e);
			}
			
		}
	}

	@Override
	@Transactional(readOnly = false)
	public void eliminarLiquidacion(Long idCalculoLiquidacion) {
		//Borramos todas sus entregas
		List<EntregaCalculoLiq> entregas = this.getEntregasCalculo(idCalculoLiquidacion);
		for (EntregaCalculoLiq entrega : entregas) {
			this.eliminarEntregaCalLiquidacion(entrega.getId());
		}
		
		//Borramos el cálculo
		genericDao.deleteById(CalculoLiquidacion.class, idCalculoLiquidacion);
	}

	@Override
	@Transactional(readOnly = false)
	public void copiarLiquidacion(Long idCalculoLiquidacion) {
	
		CalculoLiquidacion calculo = this.getCalculoById(idCalculoLiquidacion);
		if (!Checks.esNulo(calculo)) {
			CalculoLiquidacion copia = new CalculoLiquidacion();
			copia.setActuacion(calculo.getActuacion());
			copia.setAsunto(calculo.getAsunto());
			copia.setBaseCalculo(calculo.getBaseCalculo());
			copia.setCapital(calculo.getCapital());
			copia.setComisiones(calculo.getComisiones());
			copia.setContrato(calculo.getContrato());
			copia.setCostasLetrado(calculo.getCostasLetrado());
			copia.setCostasProcurador(calculo.getCostasProcurador());
			copia.setDocumentoId(calculo.getDocumentoId());
			copia.setEstadoCalculo(calculo.getEstadoCalculo());
			copia.setFechaCierre(calculo.getFechaCierre());
			copia.setFechaLiquidacion(calculo.getFechaLiquidacion());
			copia.setGastos(calculo.getGastos());
			copia.setImpuestos(calculo.getImpuestos());
			copia.setInteresesDemora(calculo.getInteresesDemora());
			copia.setInteresesOrdinarios(calculo.getInteresesOrdinarios());
			copia.setNombre("Copia " + calculo.getNombre());
			copia.setNombrePersona(calculo.getNombrePersona());
			copia.setOtrosGastos(calculo.getOtrosGastos());
			copia.setTipoMoraCierre(calculo.getTipoMoraCierre());
			copia.setTotalCaculo(calculo.getTotalCaculo());
			copia.setAuditoria(Auditoria.getNewInstance());
			
			genericDao.save(CalculoLiquidacion.class, copia);
			
			//Ahora copiamos las actualizaciones tipo interes
			for (ActualizacionTipoCalculoLiq actu : calculo.getActualizacionesTipo()) {
				ActualizacionTipoCalculoLiq copiaActu = new ActualizacionTipoCalculoLiq();
				copiaActu.setCalculoLiquidacion(copia);
				copiaActu.setFecha(actu.getFecha());
				copiaActu.setTipoInteres(actu.getTipoInteres());
				copiaActu.setAuditoria(Auditoria.getNewInstance());
				
				genericDao.save(ActualizacionTipoCalculoLiq.class, copiaActu);
			}
			
			//Ahora copiamos las entregas
			for (EntregaCalculoLiq entrega : this.getEntregasCalculo(idCalculoLiquidacion)) {
				EntregaCalculoLiq copiaEntrega = new EntregaCalculoLiq();
				copiaEntrega.setCalculoLiquidacion(copia);
				copiaEntrega.setConceptoEntrega(entrega.getConceptoEntrega());
				copiaEntrega.setFechaEntrega(entrega.getFechaEntrega());
				copiaEntrega.setFechaValor(entrega.getFechaValor());
				copiaEntrega.setGastosLetrado(entrega.getGastosLetrado());
				copiaEntrega.setGastosProcurador(entrega.getGastosProcurador());
				copiaEntrega.setOtrosGastos(entrega.getOtrosGastos());
				copiaEntrega.setTipoEntrega(entrega.getTipoEntrega());
				copiaEntrega.setTotalEntrega(entrega.getTotalEntrega());
				copiaEntrega.setAuditoria(Auditoria.getNewInstance());

				genericDao.save(EntregaCalculoLiq.class, copiaEntrega);
			}
		}
	}

}
