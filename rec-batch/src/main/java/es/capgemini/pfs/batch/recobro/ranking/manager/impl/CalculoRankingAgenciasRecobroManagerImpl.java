package es.capgemini.pfs.batch.recobro.ranking.manager.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.batch.configuracion.dao.ConfiguracionEntradaDao;
import es.capgemini.pfs.batch.recobro.facturacion.dao.EXTRecobroCobroPagoDAO;
import es.capgemini.pfs.batch.recobro.ranking.manager.CalculoRankingAgenciasRecobroManager;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.DateUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dao.api.RecobroAccionesExtrajudicialesDaoApi;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroDDResultadoGestionTelefonica;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.contrato.dao.CicloRecobroContratoDao;
import es.pfsgroup.recovery.recobroCommon.contrato.model.CicloRecobroContrato;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroSubCarteraRankingDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraAgencia;
import es.pfsgroup.recovery.recobroCommon.persona.dao.api.CicloRecobroPersonaDao;
import es.pfsgroup.recovery.recobroCommon.persona.model.CicloRecobroPersona;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.EXTRecobroCobroPago;
import es.pfsgroup.recovery.recobroCommon.ranking.dao.api.RecobroRankingHistoricoSubcarteraDAO;
import es.pfsgroup.recovery.recobroCommon.ranking.manager.api.RecobroRankingSubcarteraDetalleManager;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroDDVariableRanking;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloRankingVariable;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingSubcartera;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingSubcarteraComparator;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingSubcarteraDetalle;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroRankingSubcarteraDetalleComparator;
import es.pfsgroup.recovery.recobroCommon.ranking.model.api.RecobroRankingSubcarteraManagerApi;

@Service
public class CalculoRankingAgenciasRecobroManagerImpl implements
		CalculoRankingAgenciasRecobroManager {

	@Autowired
	private RecobroRankingHistoricoSubcarteraDAO recobroRankingHistoricoSubcarteraDAO;
	
	@Autowired
	private ConfiguracionEntradaDao configuracionEntradaDao;
	
	@Autowired
	private RecobroSubCarteraRankingDao recobroSubCarteraRankingDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private RecobroRankingSubcarteraManagerApi recobroRankingSubcarteraManager;
	
	@Autowired
	private RecobroRankingSubcarteraDetalleManager recobroRankingSubcarteraDetalleManager;
	
	@Autowired
	private CicloRecobroContratoDao cicloRecobroContratoDao;
	
	@Autowired
	private CicloRecobroPersonaDao cicloRecobroPersonaDao;
	
	@Autowired
	private RecobroAccionesExtrajudicialesDaoApi recobroAccionesExtrajudicialesDao;
	
	@Autowired
	private EXTRecobroCobroPagoDAO recobroCobroPagoDAO;
	
	@Override
	public void CalcularRanking() {
		// Obtenemos las fechas de inicio y fin del intervalo
		Date fechaInicial = DateUtils.clearDateTime(recobroRankingHistoricoSubcarteraDAO.obtenerUltimaFechaRanking());
		if (fechaInicial==null) {
			//Puede que no se haya realizado el ranking nunca
			//por lo tanto utilizamos como fecha de inicio, el primer dia del a�o actual
			Calendar cal = Calendar.getInstance();
			cal.set(Calendar.DAY_OF_YEAR, 1);
			cal.set(Calendar.MONTH, 1);
			fechaInicial = DateUtils.clearDateTime(cal.getTime());
		}
		Date fechaFinal = DateUtils.addDays(DateUtils.getTodayWithoutTime(), -1);		

		//Tenemos que truncar las 2 tablas de destino
		recobroRankingSubcarteraManager.truncarRankingSubcartera();
		recobroRankingSubcarteraDetalleManager.truncarRankingSubcarteraDetalle();
		
		//Obtenemos las subcarteras de los esquemas liberados o en Extincion
		List<Object[]> subcarteras = configuracionEntradaDao.obtenerEsquemasSubCarterasPorEstadosEsquema(new String[] {"LBR","EXG"});
		//int i=0;
		//Por cada subcartera calculamos el detalle de cada variable para cada agencia 
		for (Object[] subcartera : subcarteras) {
		//while (i<subcarteras.size()) {	
			RecobroSubCartera recobroSubCartera = genericDao.get(RecobroSubCartera.class, genericDao.createFilter(FilterType.EQUALS, "id", subcartera[1]));
			List<RecobroModeloRankingVariable> recobroModeloRankingVariables = recobroSubCartera.getModeloDeRanking().getModeloRankingVariables();
			List<RecobroSubcarteraAgencia> recobroSubcarteraAgencias = recobroSubCartera.getAgencias();
			
			for (RecobroModeloRankingVariable recobroModeloRankingVariable : recobroModeloRankingVariables) {
				//Variable Contactabilidad
				if(recobroModeloRankingVariable.getVariableRanking().getCodigo().equals(RecobroDDVariableRanking.CODIGO_CONTACTABILIDAD)){
					List<RecobroRankingSubcarteraDetalle> rankingDetalles = new ArrayList<RecobroRankingSubcarteraDetalle>();
					for (RecobroSubcarteraAgencia recobroSubcarteraAgencia : recobroSubcarteraAgencias) {
						RecobroAgencia agencia = recobroSubcarteraAgencia.getAgencia();
						
						// Calculo del resultado de la variable: contactabilidad
						Float resultado = calcularContactabilidad(agencia, recobroSubCartera, fechaInicial, fechaFinal);
						rankingDetalles.add(crearDetalle(resultado, agencia, recobroSubCartera, recobroModeloRankingVariable));
					} //For agencia
					// Para los objetos obtenidos calculo su posici�n
					rellenarPosicionDetalles(rankingDetalles);
					
					// Guardo todos los objetos RSD_RANKING_SUBCAR_DETALLE
					recobroRankingSubcarteraDetalleManager.guardarDetalles(rankingDetalles);
					
				}//if variable Contactabilidad
				
				//Variable Cobertura : 
				if(recobroModeloRankingVariable.getVariableRanking().getCodigo().equals(RecobroDDVariableRanking.CODIGO_CONTACTABILIDAD)){
					List<RecobroRankingSubcarteraDetalle> rankingDetalles = new ArrayList<RecobroRankingSubcarteraDetalle>();
					for (RecobroSubcarteraAgencia recobroSubcarteraAgencia : recobroSubcarteraAgencias) {
						RecobroAgencia agencia = recobroSubcarteraAgencia.getAgencia();
						
						// Calculo del resultado de la variable: Cobertura
						Float resultado = calcularCobertura(agencia, recobroSubCartera, fechaInicial, fechaFinal);
						rankingDetalles.add(crearDetalle(resultado, agencia, recobroSubCartera, recobroModeloRankingVariable));
					} //For agencia
					// Para los objetos obtenidos calculo su posici�n
					rellenarPosicionDetalles(rankingDetalles);
					
					// Guardo todos los objetos RSD_RANKING_SUBCAR_DETALLE
					recobroRankingSubcarteraDetalleManager.guardarDetalles(rankingDetalles);										
					
				}//if Cobertura
				
				/*
				 	FASE 2
				 
				//Variable Calidad Gestion
				if(recobroModeloRankingVariable.getVariableRanking().getCodigo().equals(RecobroDDVariableRanking.CODIGO_CALIDAD_GESTION)){
					List<RecobroRankingSubcarteraDetalle> rankingDetalles = new ArrayList<RecobroRankingSubcarteraDetalle>();
					for (RecobroSubcarteraAgencia recobroSubcarteraAgencia : recobroSubcarteraAgencias) {
						RecobroAgencia agencia = recobroSubcarteraAgencia.getAgencia();
						
						// Calculo del resultado de la variable: calidad gesti�n
						Float resultado = calcularCalidadGestion();
						rankingDetalles.add(crearDetalle(resultado, agencia, recobroSubCartera, recobroModeloRankingVariable));
					} //For agencia
					// Para los objetos obtenidos calculo su posici�n
					rellenarPosicionDetalles(rankingDetalles);
					
					// Guardo todos los objetos RSD_RANKING_SUBCAR_DETALLE
					recobroRankingSubcarteraDetalleManager.guardarDetalles(rankingDetalles);					
					
					
				}//if Calidad Gestion
				
				*/
				
				//Variable Eficacia sobre stock
				if(recobroModeloRankingVariable.getVariableRanking().getCodigo().equals(RecobroDDVariableRanking.CODIGO_EFICACIA_SOBRE_STOCK)){
					List<RecobroRankingSubcarteraDetalle> rankingDetalles = new ArrayList<RecobroRankingSubcarteraDetalle>();
					for (RecobroSubcarteraAgencia recobroSubcarteraAgencia : recobroSubcarteraAgencias) {
						RecobroAgencia agencia = recobroSubcarteraAgencia.getAgencia();
						
						// Calculo del resultado de la variable: eficacia stock
						Float resultado = calcularEficaciaStock(agencia, recobroSubCartera, fechaInicial, fechaFinal);
						rankingDetalles.add(crearDetalle(resultado, agencia, recobroSubCartera, recobroModeloRankingVariable));
					} //For agencia
					// Para los objetos obtenidos calculo su posici�n
					rellenarPosicionDetalles(rankingDetalles);
					
					// Guardo todos los objetos RSD_RANKING_SUBCAR_DETALLE
					recobroRankingSubcarteraDetalleManager.guardarDetalles(rankingDetalles);					
					
					
				}//if Eficacia sobre stock
			
				//Variable Eficacia sobre entradas
				if(recobroModeloRankingVariable.getVariableRanking().getCodigo().equals(RecobroDDVariableRanking.CODIGO_EFICACION_SOBRE_ENTRADAS)){
					List<RecobroRankingSubcarteraDetalle> rankingDetalles = new ArrayList<RecobroRankingSubcarteraDetalle>();
					for (RecobroSubcarteraAgencia recobroSubcarteraAgencia : recobroSubcarteraAgencias) {
						RecobroAgencia agencia = recobroSubcarteraAgencia.getAgencia();
						
						// Calculo del resultado de la variable: eficacia entradas
						Float resultado = calcularEficaciaEntradas(agencia, recobroSubCartera, fechaInicial, fechaFinal);
						rankingDetalles.add(crearDetalle(resultado, agencia, recobroSubCartera, recobroModeloRankingVariable));
					} //For agencia
					// Para los objetos obtenidos calculo su posici�n
					rellenarPosicionDetalles(rankingDetalles);
					
					// Guardo todos los objetos RSD_RANKING_SUBCAR_DETALLE
					recobroRankingSubcarteraDetalleManager.guardarDetalles(rankingDetalles);					
					
					
				}//if Eficacia sobre entradas					
			}//for ModeloRankingVariables					
			//i++;
		}//for subcarteras
		
		// Calculamos el ranking global a partir de los detalles calculados anteriormente por subcartera
		List<RecobroRankingSubcartera> subCarterasRanking;
		RecobroRankingSubcartera rankingsubcartera;
		
		//i=0;
		for (Object[] subcartera : subcarteras) {
		//while (i<subcarteras.size()) {	
			subCarterasRanking = new ArrayList<RecobroRankingSubcartera>();
			//Calculamos el coeficiencia de cada agencia
			RecobroSubCartera recobroSubCartera = genericDao.get(RecobroSubCartera.class, genericDao.createFilter(FilterType.EQUALS, "id", subcartera[1]));
			List<RecobroSubcarteraAgencia> recobroSubcarteraAgencias = recobroSubCartera.getAgencias();

			for (RecobroSubcarteraAgencia agencia : recobroSubcarteraAgencias) {
				Integer CoeficienteAgencia = 0;
				List<RecobroRankingSubcarteraDetalle> detalles = recobroRankingSubcarteraDetalleManager.obtenerDetallesAgenciaId(agencia.getId());
				for (RecobroRankingSubcarteraDetalle detalle : detalles) {
					CoeficienteAgencia = CoeficienteAgencia + (int)((detalle.getPeso()/100) * (detalle.getResultado()/100));
				}
				
				rankingsubcartera = new RecobroRankingSubcartera();
				rankingsubcartera.setAgencia(agencia.getAgencia());
				rankingsubcartera.setSubCartera(recobroSubCartera);
				rankingsubcartera.setPorcentaje(CoeficienteAgencia);
				
				subCarterasRanking.add(rankingsubcartera);
			}
			
			//Ordeno y relleno la posicion de la lista de subCarterasRanking
			rellenarPosicionRanking(subCarterasRanking);
			//Ahora que ya tenemos la posicion, hay que rellenar su porcentaje antes de guardarlo
			rellenarPorcentaje(subCarterasRanking);
			// guardarlo en RAS_RANKING_SUBCARTERA 
			recobroRankingSubcarteraManager.guardarRankings(subCarterasRanking);
			//i++;
		}
		
		//Historificamos las tablas de ranking
		recobroRankingHistoricoSubcarteraDAO.HistorificarRankingSubcartera();
		recobroRankingHistoricoSubcarteraDAO.HistorificarRankingSubcarteraDetalle();
		
	}
	
	/**
	 * Devuelve una nueva instancia del tipo RecobroRankingSubcarteraDetalle rellenada con los datos correspondientes 
	 * @param resultado
	 * @param agencia
	 * @param recobroSubCartera
	 * @param recobroModeloRankingVariable
	 * @return
	 */
	private RecobroRankingSubcarteraDetalle crearDetalle(Float resultado, RecobroAgencia agencia, RecobroSubCartera recobroSubCartera, RecobroModeloRankingVariable recobroModeloRankingVariable) {
		RecobroRankingSubcarteraDetalle detalle = new RecobroRankingSubcarteraDetalle();
		detalle.setAgencia(agencia);
		detalle.setSubCartera(recobroSubCartera);
		detalle.setVariableRanking(recobroModeloRankingVariable.getVariableRanking());
		detalle.setPeso(recobroModeloRankingVariable.getCoeficiente());
		detalle.setResultado(resultado);
		
		return detalle;
	}
	
	private void rellenarPosicionDetalles(List<RecobroRankingSubcarteraDetalle> detalles) {
		//Ordenamos los detalles por su Resultado
		Collections.sort(detalles,new RecobroRankingSubcarteraDetalleComparator());
		//Y luego ordenamos su posicion
		int posicion = 0;
		while (posicion < detalles.size()) {
			detalles.get(posicion).setPosicion(posicion+1);
			posicion++;
		}
	}
	
	private void rellenarPosicionRanking(List<RecobroRankingSubcartera> subcarteras) {
		//Ordenamos el ranking por su reparto
		Collections.sort(subcarteras, new RecobroRankingSubcarteraComparator());
		//Y luego rellenamos su posicion
		int posicion = 0;
		while (posicion < subcarteras.size()) {
			subcarteras.get(posicion).setPosicion(posicion+1);
			posicion++;
		}
	}
	
	private void rellenarPorcentaje(List<RecobroRankingSubcartera> subCarterasRanking) {
		for (RecobroRankingSubcartera recobroRankingSubcartera : subCarterasRanking) {
			recobroRankingSubcartera.setPorcentaje(recobroSubCarteraRankingDao.getPorcentaje(recobroRankingSubcartera.getSubCartera(), recobroRankingSubcartera.getPosicion()));
		}
	}
	
	/**
	 * Realiza el calculo de la contactabilidad
	 * Contactos correctos (CU) / cant. contactos intentados ('CNU', 'SC', 'BUZ', 'COM', 'NE', 'NC', 'CU')
	 * @param agencia
	 * @param recobroSubCartera
	 * @param fechainicial
	 * @param fechaFinal
	 * @return
	 */
	private Float calcularContactabilidad(RecobroAgencia agencia, RecobroSubCartera recobroSubCartera, Date fechaInicial, Date fechaFinal){
	
		List<String> codigosContactosIntentados = new ArrayList<String>();
		List<String> codigosContactosCorrectos = new ArrayList<String>();
		Float contactosIntentados = new Float(0);
		Float contactosCorrectos = new Float(0);
		codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_SIN_CONTACTO);
		codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_CONTACTO_UTIL);
		//codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_CONTACTO_UTIL_POSITIVO);
		codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_COMPROMISO_PAGO_PARCIAL);
		codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_COMPROMISO_PAGO_TOTAL);
		codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_ACUERDO_PALANCA);
		//codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_COBRO_PARCIAL);
		//codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_COBRO_TOTAL);
		codigosContactosCorrectos.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_CONTACTO_UTIL);
		// Obtenemos todos los ciclos de recobro de contrato de una subcartera/agencia para un determinado intervalo de fechas
		List<CicloRecobroContrato> ciclosRecobroContrato = cicloRecobroContratoDao.getCiclosRecobroContratoPorAgenciaSubcarteraIntervaloFechas(
				recobroSubCartera.getId(), agencia.getId(), fechaInicial, fechaFinal);
		// Para cada contrato de los ciclos de recobro calculados obtenemos sus acciones extrajudiciales de contactos correctos y contactos intentados
		for (CicloRecobroContrato cicloRecobroContrato : ciclosRecobroContrato) {
			contactosIntentados += recobroAccionesExtrajudicialesDao.getAccionesPorAgenciaContratoIntervaloFechaGestionResultados(agencia, 
					cicloRecobroContrato.getContrato(), fechaInicial, fechaFinal, codigosContactosIntentados).size();
			contactosCorrectos += recobroAccionesExtrajudicialesDao.getAccionesPorAgenciaContratoIntervaloFechaGestionResultados(agencia, 
					cicloRecobroContrato.getContrato(), fechaInicial, fechaFinal, codigosContactosCorrectos).size();
		}		
		return contactosCorrectos/contactosIntentados;
	}	

	/**
	 * Realiza el calculo de la eficacia sobre el stock
	 * Importe Recobrado s/ Volumen a Gestionar
	 * @param agencia
	 * @param recobroSubCartera
	 * @param fechainicial
	 * @param fechaFinal
	 * @return
	 */
	private Float calcularEficaciaStock(RecobroAgencia agencia, RecobroSubCartera recobroSubCartera, Date fechaInicial, Date fechaFinal){
		
		Float volumenRecobrado = new Float(0);
		Float volumenGestionadoIrregulartotal = new Float(0);
		// Obtenemos todos los ciclos de recobro de contrato de una subcartera/agencia para un determinado intervalo de fechas
		List<CicloRecobroContrato> ciclosRecobroContrato = cicloRecobroContratoDao.getCiclosRecobroContratoPorAgenciaSubcarteraIntervaloFechas(
				recobroSubCartera.getId(), agencia.getId(), fechaInicial, fechaFinal);
		// Para cada contrato de los ciclos de recobro calculados obtenemos su volumen irregular total gestionado y sus cobros recobrados asociados
		for (CicloRecobroContrato cicloRecobroContrato : ciclosRecobroContrato) {
			volumenGestionadoIrregulartotal += cicloRecobroContrato.getPosVivaVencida();
			List<EXTRecobroCobroPago> extRecobroCobroPagos = recobroCobroPagoDAO.obtenerCobrosPagosPorContratoIntervaloFecha(
					cicloRecobroContrato.getContrato(), fechaInicial, fechaFinal);
			for (EXTRecobroCobroPago extRecobroCobroPago : extRecobroCobroPagos) {
				volumenRecobrado += extRecobroCobroPago.getImporte();
			}
		}		
		return volumenRecobrado/volumenGestionadoIrregulartotal;		

	}
	
	/**
	 * Realiza el calculo de la eficacia de las entradas
	 * Importe Recobrado de entradas s/ Importe Irregular de entradas
	 * @param agencia
	 * @param recobroSubCartera
	 * @param fechainicial
	 * @param fechaFinal
	 * @return
	 */
	private Float calcularEficaciaEntradas(RecobroAgencia agencia, RecobroSubCartera recobroSubCartera, Date fechaInicial, Date fechaFinal){

		Float volumenRecobradoEntradas = new Float(0);
		Float volumenGestionadoIrregularTotalEntradas = new Float(0);
		// Obtenemos todos los ciclos de recobro de las entradas de contratos de una subcartera/agencia para un determinado intervalo de fechas
		List<CicloRecobroContrato> ciclosRecobroContrato = cicloRecobroContratoDao.getCiclosRecobroEntradasContratoPorAgenciaSubcarteraIntervaloFechas(
				recobroSubCartera.getId(), agencia.getId(), fechaInicial, fechaFinal);
		// Para cada contrato de los ciclos de recobro de las entradas calculadas obtenemos su volumen irregular total gestionado y sus cobros recobrados asociados
		for (CicloRecobroContrato cicloRecobroContrato : ciclosRecobroContrato) {
			volumenGestionadoIrregularTotalEntradas += cicloRecobroContrato.getPosVivaVencida();
			List<EXTRecobroCobroPago> extRecobroCobroPagos = recobroCobroPagoDAO.obtenerCobrosPagosPorContratoIntervaloFecha(
					cicloRecobroContrato.getContrato(), fechaInicial, fechaFinal);
			for (EXTRecobroCobroPago extRecobroCobroPago : extRecobroCobroPagos) {
				volumenRecobradoEntradas += extRecobroCobroPago.getImporte();
			}
		}		
		return volumenRecobradoEntradas/volumenGestionadoIrregularTotalEntradas;		
		
	}
	
	/**
	 * Realiza el calculo de la cobertura
	 * Personas diferentes con intento de contacto / Personas totales diferentes en gesti�n
	 * @param agencia
	 * @param recobroSubCartera
	 * @param fechainicial
	 * @param fechaFinal
	 * @return
	 */
	private Float calcularCobertura(RecobroAgencia agencia, RecobroSubCartera recobroSubCartera, Date fechaInicial, Date fechaFinal){
		
		List<String> codigosContactosIntentados = new ArrayList<String>();
		Float contactosIntentados = new Float(0);
		Float personasTotales = new Float(0);
		codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_SIN_CONTACTO);
		codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_CONTACTO_UTIL);
		//codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_CONTACTO_UTIL_POSITIVO);
		codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_COMPROMISO_PAGO_PARCIAL);
		codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_COMPROMISO_PAGO_TOTAL);
		codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_ACUERDO_PALANCA);
		//codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_COBRO_PARCIAL);
		//codigosContactosIntentados.add(RecobroDDResultadoGestionTelefonica.RESULTADO_GESTION_TELEFONICA_CODIGO_COBRO_TOTAL);
		// Obtenemos todos los ciclos de recobro de personas de una subcartera/agencia para un determinado intervalo de fechas
		List<CicloRecobroPersona> ciclosRecobroPersona = cicloRecobroPersonaDao.getCiclosRecobroPersonaPorAgenciaSubcarteraIntervaloFechas(
				recobroSubCartera.getId(), agencia.getId(), fechaInicial, fechaFinal);
		List<Persona> personas = new ArrayList<Persona>();
		// Consolidamos la lista de personas para que no haya repetidas
		for (CicloRecobroPersona cicloRecobroPersona : ciclosRecobroPersona) {
			if(!personas.contains(cicloRecobroPersona.getPersona()))personas.add(cicloRecobroPersona.getPersona());
		}
		personasTotales += personas.size();
		// Para cada persona distinta obtenemos sus acciones extrajudiciales de contactos intentados
		for (Persona persona : personas) {
			if(recobroAccionesExtrajudicialesDao.getAccionesPorAgenciaPersonaIntervaloFechaGestionResultados(agencia, 
					persona, fechaInicial, fechaFinal, codigosContactosIntentados).size()>0)
			contactosIntentados += 1;
		}
		return contactosIntentados/personasTotales;
		
	}
	
	/**
	 * Realiza el calculo de la calidad del acuerdo
	 * Acuerdos cumplidos (AC) / Acuerdo propuesto (AP)
	 * @param agencia
	 * @param recobroSubCartera
	 * @param fechainicial
	 * @param fechaFinal
	 * @return
	 */
	@SuppressWarnings("unused")
	private Float calcularCalidadAcuerdo(RecobroAgencia agencia, RecobroSubCartera recobroSubCartera, Date fechaInicial, Date fechaFinal){
		//TODO: Se deja para la Fase 2
		Random rand = new Random();
		return rand.nextFloat();
	}
	
	/**
	 * Realiza el calculo de la calidad de la gesti�n. 
	 * Acuerdo propuesto (AP) / Contacto �til (CU)
	 * @param agencia
	 * @param recobroSubCartera
	 * @param fechainicial
	 * @param fechaFinal
	 * @return
	 */
	@SuppressWarnings("unused")
	private Float calcularCalidadGestion(RecobroAgencia agencia, RecobroSubCartera recobroSubCartera, Date fechaInicial, Date fechaFinal){
		//TODO: Se deja para la Fase 2
		Random rand = new Random();
		return rand.nextFloat();
	}

}