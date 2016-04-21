package es.pfsgroup.plugin.liquidaciones.avanzado.manager;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.ContratoManager;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.multigestor.EXTGestorAdicionalAsuntoManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionCabecera;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionResumen;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoReportRequest;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoTramoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQReportTiposIntereses;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQTramoPendientes;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.LIQCobroPagoDao;
import es.pfsgroup.plugin.recovery.liquidaciones.model.LIQCobroPago;

@Service
public class LiquidacionesAvanzadoManager {
	
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
	
	public LIQDtoLiquidacionCabecera completarCabecera(LIQDtoReportRequest request) {
		LIQDtoLiquidacionCabecera cabecera = new LIQDtoLiquidacionCabecera();

		
		Procedimiento proc = procedimientoManager.getProcedimiento(request.getActuacion());
		Contrato cont = contratoManager.get(request.getContrato());
		Assertions.assertNotNull(proc, "plugin.liquidaciones.error.procedimiento.null");
		Assertions.assertNotNull(cont, "plugin.liquidaciones.error.contrato.null");
		
		Date fechaCierre;
		Date fechaCalculo;
		Date fechaVencimiento;
		try {
			fechaCierre = DateFormat.toDate(request.getFechaCierre());
			fechaCalculo = DateFormat.toDate(request.getFechaDeLiquidacion());
			fechaVencimiento = DateFormat.toDate(request.getFechaVencimiento());
		} catch (ParseException e) {
			throw new BusinessOperationException("plugin.liquidaciones.error.date.format");
		}
		
		cabecera.setFechaCalculo(fechaCalculo);
		
		cabecera.setNumCuenta(cont.getNroContratoFormat());
		cabecera.setNombre(request.getNombre());
		cabecera.setDni(request.getDni());
		
		cabecera.setCapital(new BigDecimal(cont.getLimiteInicial().toString()));
		cabecera.setFechaVencimiento(fechaVencimiento);
		cabecera.setInteres(request.getInteresesOrdinarios());
		cabecera.setTipoInteres(request.getTipoInteres());
		cabecera.setTipoIntDemora(request.getTipoDemoraCierre());
		
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

	public List<LIQDtoTramoLiquidacion> obtenerLiquidaciones(LIQDtoReportRequest request, LIQTramoPendientes pendientes) {
		List<LIQDtoTramoLiquidacion> cuerpo = new ArrayList<LIQDtoTramoLiquidacion>();
		
		Date fechaCierre;
		Date fechaCalculo;
		try {
			fechaCierre = DateFormat.toDate(request.getFechaCierre());
			fechaCalculo = DateFormat.toDate(request.getFechaDeLiquidacion());
		} catch (ParseException e) {
			throw new BusinessOperationException("plugin.liquidaciones.error.date.format");
		}
		
		//1.- Tramo inicial
		Date fecha = fechaCierre;
		Float tipoInt = request.getTipoDemoraCierre();
		
		LIQDtoTramoLiquidacion tramoInicial = new LIQDtoTramoLiquidacion();
		tramoInicial.setFechaValor(DateFormat.toString(fecha));
		tramoInicial.setDescripcion("Principal reclamado");
		tramoInicial.setSaldo(pendientes.getSaldo());
		tramoInicial.setInteresesPendientes(pendientes.getIntereses());
		cuerpo.add(tramoInicial);
		
		//2. - Ahora van los diferentes tramos, que son las entregas a cuenta y los cambios de tipo de interés
		List<LIQCobroPago> entregasCuenta = cobrosPagosDao.findEntregasACuenta(request.getContrato(), fechaCierre, fechaCalculo);
		
		for (LIQCobroPago ec : entregasCuenta) {
			//Obtenemos los cambios de tipos intermedios
			Map<List<LIQDtoTramoLiquidacion>, Float> cambios = cambiosTipoEntreFechas(request, fecha, ec.getFecha(), pendientes.getSaldo(), pendientes.getIntereses(), tipoInt);
			//Agregamos los tramos y vamos avanzado la fecha y actualizando el tipo de interes
			for (LIQDtoTramoLiquidacion cambio : cambios.keySet().iterator().next()) {
				cuerpo.add(cambio);
				try {
					fecha = DateFormat.toDate(cambio.getFechaValor());
				} catch (ParseException e) {}
			}
			if (cambios.keySet().iterator().next()!=null) {
				//Actualizamos el útlimo tipo interes demora
				tipoInt = cambios.get(cambios.keySet().iterator().next());
			}
			
			//Ahora creamos el tramo para la entrega cuenta
			LIQDtoTramoLiquidacion tramo = generarTramoParaEntrega(ec, fecha, tipoInt, request.getBaseCalculo(), pendientes);
			
			// Y lo agregamos al cuerpo
			cuerpo.add(tramo);
			
			//Avanzamos fecha
			fecha = ec.getFecha();
		}
		
		//Ahora insertamos los cambios de tipo entre la ultima entrega y la fecha de calculo
		Map<List<LIQDtoTramoLiquidacion>, Float> cambios = cambiosTipoEntreFechas(request, fecha, fechaCalculo, pendientes.getSaldo(), pendientes.getIntereses(), tipoInt);
		for (LIQDtoTramoLiquidacion cambio : cambios.keySet().iterator().next()) {
			cuerpo.add(cambio);
			try {
				fecha = DateFormat.toDate(cambio.getFechaValor());
			} catch (ParseException e) {}				
		}
		if (cambios.keySet().iterator().next()!=null) {		
			//Actualizamos el útlimo tipo interes demora
			tipoInt = cambios.get(cambios.keySet().iterator().next());
		}
	
		
		//3.- Por último el tramo del Calculo de Deuda, desde la última fecha hasta la fecha Calculo
		LIQDtoTramoLiquidacion ultTramo = new LIQDtoTramoLiquidacion();
		ultTramo.setFechaValor(request.getFechaDeLiquidacion());
		ultTramo.setDescripcion("C\u00E1lculo deuda");
		ultTramo.setSaldo(pendientes.getSaldo());
		ultTramo.setInteresesPendientes(pendientes.getIntereses());
		
		ultTramo.setImpuestosPendientes(pendientes.getImpuestos());
		ultTramo.setComisionesPendientes(pendientes.getComisiones());
		ultTramo.setGastosPendientes(pendientes.getGastos());
		ultTramo.setCostasLetradoPendientes(pendientes.getCostasLetrado());
		ultTramo.setCostasProcuradorPendientes(pendientes.getCostasProcurador());
		
		ultTramo.setDias(diferenciaDias(fecha, fechaCalculo));
		ultTramo.setTipoDemora(tipoInt);
		ultTramo.setInteresesDemora(calcularInteresesDemora(pendientes.getSaldo(), ultTramo.getDias(), tipoInt, request.getBaseCalculo()));
		
		cuerpo.add(ultTramo);
		
		return cuerpo;
	}
	
	private LIQDtoTramoLiquidacion generarTramoParaEntrega(LIQCobroPago ec, Date fechaAnt, Float tipoInt, int baseCalculo, LIQTramoPendientes pendientes) {
		
		Boolean entregaDesglosada = new Boolean(usuarioManager.getUsuarioLogado().getEntidad().configValue("CobrosDesglosados", "false"));
		LIQDtoTramoLiquidacion tramo = new LIQDtoTramoLiquidacion();

		if (entregaDesglosada) {
			tramo = tramoEntregaDesglosada(ec, fechaAnt, tipoInt, baseCalculo, pendientes);
		} else {
			tramo = tramoEntregaNoDesglosada(ec, fechaAnt, tipoInt, baseCalculo, pendientes);
		}
		
		//Datos iguales de metodo desglosado o no
		tramo.setFechaValor(DateFormat.toString(ec.getFechaValor()));
		tramo.setDescripcion("Entrega");
		if (!Checks.esNulo(ec.getImporte())) {
			tramo.setImporte(new BigDecimal(ec.getImporte().toString()));
		}
		tramo.setInteresesPendientes(pendientes.getIntereses());
		tramo.setImpuestosPendientes(pendientes.getImpuestos());
		tramo.setComisionesPendientes(pendientes.getComisiones());
		tramo.setGastosPendientes(pendientes.getGastos());
		tramo.setCostasLetradoPendientes(pendientes.getCostasLetrado());
		tramo.setCostasProcuradorPendientes(pendientes.getCostasProcurador());
		tramo.setTipoDemora(tipoInt);
		
		return tramo;
	}
	
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
	
	private LIQDtoTramoLiquidacion tramoEntregaNoDesglosada(LIQCobroPago ec, Date fechaAnt, Float tipoInt, int baseCalculo, LIQTramoPendientes pendientes) {
		LIQDtoTramoLiquidacion tramo = new LIQDtoTramoLiquidacion();
		
		BigDecimal importeECRestante = (!Checks.esNulo(ec.getImporte())?new BigDecimal(ec.getImporte().toString()):BigDecimal.ZERO); 
		
		//De la entrega primero reducimos de los intereses pendientes
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
		
		tramo.setDias(diferenciaDias(fechaAnt, ec.getFechaValor()));
		tramo.setInteresesDemora(calcularInteresesDemora(pendientes.getSaldo(), tramo.getDias(), tipoInt, baseCalculo));		
		
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
		
		return tramo;
	}
	
	
	
	private int diferenciaDias(Date fechaInicio, Date fechaFin) {
		Calendar calInicio = Calendar.getInstance();
		calInicio.setTime(fechaInicio);
		
		Calendar calFin = Calendar.getInstance();
		calFin.setTime(fechaFin);
		
		long diffMili = calFin.getTimeInMillis() - calInicio.getTimeInMillis();
		
		return (int) (diffMili / (24 * 60 * 60 * 1000));
	}
	
	private BigDecimal calcularInteresesDemora(BigDecimal saldo, int dias, Float tipoDemora, int baseCalculo) {
		BigDecimal resultado = saldo.multiply(new BigDecimal(dias));
		resultado = resultado.multiply(new BigDecimal(tipoDemora.toString()));
		resultado = resultado.divide(new BigDecimal(baseCalculo * 100), 2, RoundingMode.HALF_UP);
		
		return resultado;
	}
	
	private HashMap<List<LIQDtoTramoLiquidacion>, Float> cambiosTipoEntreFechas(LIQDtoReportRequest request, Date fechaDesde, Date fechaHasta, BigDecimal saldo, BigDecimal intereses, Float tipoInt) {
		Calendar c = Calendar.getInstance();
		List<LIQDtoTramoLiquidacion> tramos = new ArrayList<LIQDtoTramoLiquidacion>();
		Date fecha = fechaDesde;
		Float tipo = tipoInt; 
		
		//Mientras tengamos cambios de interes entre la fecha y la entregaCuenta
		LIQReportTiposIntereses cambioTipoInteres;
		do {
			cambioTipoInteres = request.getPrimerCambioEntreFechas(fecha, fechaHasta);
			if (cambioTipoInteres!=null) {
				Date fechaCambio =  null;
				try {
					fechaCambio = DateFormat.toDate(cambioTipoInteres.getFecha());
				} catch (ParseException e) {}
				//Creamos una línea de tipo de Cambio de Tipo de Interes
				
				LIQDtoTramoLiquidacion tramoCambioTipo = new LIQDtoTramoLiquidacion();
				tramoCambioTipo.setFechaValor(DateFormat.toString(fechaCambio));
				tramoCambioTipo.setDescripcion("Cambio inter\u00E9s de demora");
				tramoCambioTipo.setSaldo(saldo);
				tramoCambioTipo.setInteresesPendientes(intereses);
				tramoCambioTipo.setDias(diferenciaDias(fecha, fechaCambio));
				tramoCambioTipo.setTipoDemora(tipo);
				tramoCambioTipo.setInteresesDemora(calcularInteresesDemora(saldo, tramoCambioTipo.getDias(),tipo, request.getBaseCalculo()));
				
				//Avanzamos la fecha y actualizamos el tipoInt
				fecha = fechaCambio;
				//Avanzamos un día
				c.setTime(fecha); 
				c.add(Calendar.DATE, 1);
				fecha = c.getTime();				
				tipo = cambioTipoInteres.getTipoInteres();
				
				tramos.add(tramoCambioTipo);
			}
		} while (cambioTipoInteres !=null);		
		
		HashMap<List<LIQDtoTramoLiquidacion>,Float> resultado = new HashMap<List<LIQDtoTramoLiquidacion>, Float>();
		resultado.put(tramos, tipo);
		
		return resultado;
	}

	public LIQDtoLiquidacionResumen crearResumen(LIQDtoReportRequest request, List<LIQDtoTramoLiquidacion> cuerpo) {
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
			//Y le sumamos los intereses pendientes por pagar
			totalDeuda = totalDeuda.add(ultTramo.getInteresesPendientes());
			// Y le sumamos todos los intereses demora calculados
			for (LIQDtoTramoLiquidacion tramo : cuerpo) {
				if (tramo.getInteresesDemora()!=null) {
					totalDeuda = totalDeuda.add(tramo.getInteresesDemora());
				}
			}
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
		
		//Total a pagar
		BigDecimal totalPagar = BigDecimal.ZERO;
		totalPagar = totalPagar.add(totalDeuda);
		totalPagar = totalPagar.add(impuestos);
		totalPagar = totalPagar.add(comisiones);
		totalPagar = totalPagar.add(costasLetrado);
		totalPagar = totalPagar.add(costasProcurador);
		totalPagar = totalPagar.add(gastos);
		
		resumen.setTotalPagar(totalPagar);
		
		return resumen;
	}
	
}
