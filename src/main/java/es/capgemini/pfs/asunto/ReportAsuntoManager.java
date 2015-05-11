package es.capgemini.pfs.asunto;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.EXTAsuntoDao; 
import es.capgemini.pfs.asunto.dto.DtoReportAnotacionAgenda;
import es.capgemini.pfs.asunto.dto.DtoReportCobroPago;
import es.capgemini.pfs.asunto.dto.DtoReportComunicacion;
import es.capgemini.pfs.asunto.dto.DtoReportContrato;
import es.capgemini.pfs.asunto.dto.DtoReportFaseComun;
import es.capgemini.pfs.asunto.dto.DtoReportInstrucciones;
import es.capgemini.pfs.cobropago.dao.CobroPagoDao;
import es.capgemini.pfs.cobropago.model.CobroPago;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;

@Component
public class ReportAsuntoManager {

	public static final String GET_FASE_COMUN_ASUNTO_REPORT = "plugin.asunto.report.obtenerFaseComun";
	public static final String GET_COBROS_ASUNTO_REPORT = "plugin.asunto.report.obtenerCobros";
	public static final String GET_INSTRUCCIONES_SUBASTA_REPORT = "plugin.asunto.report.obtenerInstruccionesSubasta";
	public static final String GET_COMUNICACIONES_FICHA_GLOBAL_REPORT = "plugin.asunto.report.obtenerComunicacionesFichaGlobal";
	public static final String GET_TAREAS_PENDIENTES_ASUNTO_REPORT = "plugin.asunto.report.obtenerTareasPendientesAsunto";
	public static final String GET_CONTRATOS_ASUNTO_REPORT = "plugin.asunto.report.obtenerContratos";

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Resource
	Properties appProperties;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
    private Executor executor;
	
	@Autowired
	private EXTAsuntoDao extAsuntoDao;

	@Autowired
	private CobroPagoDao cobroPagoDao;
	
	/**
	 * Obtiene las tareas pendientes relacionadas de un asunto.
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de tareas
	 */
	@BusinessOperation(GET_TAREAS_PENDIENTES_ASUNTO_REPORT)
	public List<DtoReportAnotacionAgenda> obtenerTareasPendientesAsunto(Long idAsunto) {
		List<DtoReportAnotacionAgenda> listadoTareas = extAsuntoDao.getListaTareasPendientes(idAsunto);
		return listadoTareas;
	}


	/**
	 * Recupera las comunicaciones para la ficha global
	 * 
	 * @param idAsunto
	 * @return
	 */
	@BusinessOperation(GET_COMUNICACIONES_FICHA_GLOBAL_REPORT)
	public List<DtoReportComunicacion> getListComunicacionesFichaGlobal(Long idAsunto) {
		return new ArrayList<DtoReportComunicacion>();
	}

	/**
	 * Obtiene los riesgos origen de la actuaci�n activa del asunto.
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de riesgos
	 */
	@BusinessOperation(GET_INSTRUCCIONES_SUBASTA_REPORT)
	public List<DtoReportInstrucciones> obtenerInstruccionesSubastaAsunto(Long idAsunto) {
		return new ArrayList<DtoReportInstrucciones>();
	}
	
	/**
	 * Obtiene los cobros/pagos
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de cobros/pagos
	 */
	@BusinessOperation(GET_COBROS_ASUNTO_REPORT)
	public List<DtoReportCobroPago> obtenerCobros(Long idAsunto) {
		List<CobroPago> listadoCobrosPagos = cobroPagoDao.getByIdAsunto(idAsunto);
		List<DtoReportCobroPago> listadoRetorno = new ArrayList<DtoReportCobroPago>();
		for (CobroPago cobro : listadoCobrosPagos) {
			DtoReportCobroPago dto = new DtoReportCobroPago();
			dto.setFecha(cobro.getFecha());
			dto.setImporte(cobro.getImporte());
			listadoRetorno.add(dto);
		}
		return listadoRetorno;
	}
	
	/**
	 * Obtiene los cr�ditos de fase comun para el asunto
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de creditos insinuados
	 */
	@BusinessOperation(GET_FASE_COMUN_ASUNTO_REPORT)
	public List<DtoReportFaseComun> obtenerFaseComun(Long idAsunto) {
		return new ArrayList<DtoReportFaseComun>();
	}
	/*
	List<DtoFaseComun> listadoFaseComun = new ArrayList<DtoFaseComun>();
	
	List<DtoConcurso> lista = (List<DtoConcurso>) executor.execute("concursoManager.listadoFaseComun",idAsunto);

	
	if (!Checks.esNulo(lista)){
		for (Concurso dtoLista : lista){
			
			List<DtoContratoConcurso> listContratosConcurso = dtoLista.getContratos();
			Float riesgo = new Float(0);
			
			if (!Checks.esNulo(listContratosConcurso)){
				
				DDEstadoCredito estadoMasBajo = null;
				
				Double contraLetrado = new Double(0);
				Double generalLetrado = new Double(0);
				Double especialLetrado = new Double(0);
				Double ordinarioLetrado = new Double(0);
				Double subordinarioLetrado = new Double(0);
				Double noAdmLetrado = new Double(0);
				Double contingenteLetrado = new Double(0);
				
				Double contraFinal = new Double(0);
				Double generalFinal = new Double(0);
				Double especialFinal = new Double(0);
				Double ordinarioFinal = new Double(0);
				Double subordinarioFinal = new Double(0);
				Double noAdmFinal = new Double(0);
				Double contingenteFinal = new Double(0);
				
				DDEstadoCredito estadoCre = null;
				
				for (DtoContratoConcurso dtoContConc : listContratosConcurso){
					
					if (!Checks.esNulo(dtoContConc.getContrato()) && !Checks.esNulo(dtoContConc.getContrato().getLastMovimiento())
							&& !Checks.esNulo(dtoContConc.getContrato().getLastMovimiento().getPosVivaVencidaAbsoluta()))
						riesgo = riesgo + dtoContConc.getContrato().getLastMovimiento().getPosVivaVencidaAbsoluta();
					
					if (!Checks.esNulo(dtoContConc.getCreditos())){
						List<Credito> listCreditos = dtoContConc.getCreditos();
						
						
						if (!Checks.esNulo(listCreditos)){
							for(Credito cred : listCreditos){
								
								// Busco el estado m�s bajo
								estadoCre = cred.getEstadoCredito();
								if (estadoMasBajo == null){
									estadoMasBajo = estadoCre;
								} else if (estadoCre.getId() < estadoMasBajo.getId()){
									estadoMasBajo = estadoCre;
								}
								
								// Obtengo las insinuaciones de cada tipo, por un lado las del letrado y por otro las finales
								if(!Checks.esNulo(cred.getPrincipalExterno()) && !Checks.esNulo(cred.getTipoExterno())){
									if (cred.getTipoExterno().getCodigo().equals(UGASConstantes.TIPO_CREDITO_CONTRA_MASA))
										contraLetrado = contraLetrado + cred.getPrincipalExterno();
									else if (cred.getTipoExterno().getCodigo().equals(UGASConstantes.TIPO_CREDITO_PRIVILEGIADO_GENERAL))
										generalLetrado = generalLetrado + cred.getPrincipalExterno();
									else if (cred.getTipoExterno().getCodigo().equals(UGASConstantes.TIPO_CREDITO_PRIVILEGIADO_ESPECIAL))
										especialLetrado = especialLetrado + cred.getPrincipalExterno();
									else if (cred.getTipoExterno().getCodigo().equals(UGASConstantes.TIPO_CREDITO_ORDINARIO))
										ordinarioLetrado = ordinarioLetrado + cred.getPrincipalExterno();
									else if (cred.getTipoExterno().getCodigo().equals(UGASConstantes.TIPO_CREDITO_SUBORDINARIO))
										subordinarioLetrado = subordinarioLetrado + cred.getPrincipalExterno();
									else if (cred.getTipoExterno().getCodigo().equals(UGASConstantes.TIPO_CREDITO_NO_ADMITIDO))
										noAdmLetrado = noAdmLetrado + cred.getPrincipalExterno();	
									else if (cred.getTipoExterno().getCodigo().equals(UGASConstantes.TIPO_CREDITO_CONTINGENTE))
										contingenteLetrado = contingenteLetrado + cred.getPrincipalExterno();	
								}
								
								if(!Checks.esNulo(cred.getPrincipalDefinitivo()) && !Checks.esNulo(cred.getTipoDefinitivo())){
									if (cred.getTipoDefinitivo().getCodigo().equals(UGASConstantes.TIPO_CREDITO_CONTRA_MASA))
										contraFinal = contraFinal + cred.getPrincipalDefinitivo();
									else if (cred.getTipoDefinitivo().getCodigo().equals(UGASConstantes.TIPO_CREDITO_PRIVILEGIADO_GENERAL))
										generalFinal = generalFinal + cred.getPrincipalDefinitivo();
									else if (cred.getTipoDefinitivo().getCodigo().equals(UGASConstantes.TIPO_CREDITO_PRIVILEGIADO_ESPECIAL))
										especialFinal = especialFinal+ cred.getPrincipalDefinitivo();
									else if (cred.getTipoDefinitivo().getCodigo().equals(UGASConstantes.TIPO_CREDITO_ORDINARIO))
										ordinarioFinal = ordinarioFinal + cred.getPrincipalDefinitivo();
									else if (cred.getTipoDefinitivo().getCodigo().equals(UGASConstantes.TIPO_CREDITO_SUBORDINARIO))
										subordinarioFinal = subordinarioFinal + cred.getPrincipalDefinitivo();
									else if (cred.getTipoDefinitivo().getCodigo().equals(UGASConstantes.TIPO_CREDITO_NO_ADMITIDO))
										noAdmFinal = noAdmFinal + cred.getPrincipalDefinitivo();	
									else if (cred.getTipoDefinitivo().getCodigo().equals(UGASConstantes.TIPO_CREDITO_CONTINGENTE))
										contingenteFinal = contingenteFinal + cred.getPrincipalDefinitivo();
								}
								
							}
						}
					}
				}
				
				DtoFaseComun dto = new DtoFaseComun();
				dto.setSaldoIrregular(riesgo.toString());
				if (!Checks.esNulo(estadoMasBajo))
					dto.setEstado(estadoMasBajo.getDescripcion());
				
				dto.setContraLetrado(contraLetrado);
				dto.setGeneralLetrado(generalLetrado);
				dto.setEspecialLetrado(especialLetrado);
				dto.setOrdinarioLetrado(ordinarioLetrado);
				dto.setSubordinarioLetrado(subordinarioLetrado);
				dto.setNoAdmLetrado(noAdmLetrado);
				dto.setContingenteLetrado(contingenteLetrado);
				
				dto.setContraFinal(contraFinal);
				dto.setGeneralFinal(generalFinal);
				dto.setEspecialFinal(especialFinal);
				dto.setOrdinarioFinal(ordinarioFinal);
				dto.setSubordinarioFinal(subordinarioFinal);
				dto.setNoAdmFinal(noAdmFinal);
				dto.setContingenteFinal(contingenteFinal);
				
				listadoFaseComun.add(dto);
			}
			
		}
	}
	
	return listadoFaseComun;
	
}
*/
	
	/**
	 * Obtiene los contratos de un concurso
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de contratos
	 */
	@BusinessOperation(ReportAsuntoManager.GET_CONTRATOS_ASUNTO_REPORT)
	public List<DtoReportContrato> obtenerContratos(Long idAsunto) {
		return new ArrayList<DtoReportContrato>();
	}
	
	
}
