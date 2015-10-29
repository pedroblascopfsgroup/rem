package es.pfsgroup.concursal.concurso;

import java.text.DecimalFormat;
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
import es.capgemini.pfs.asunto.ReportAsuntoManager;
import es.capgemini.pfs.asunto.dto.DtoReportContrato;
import es.capgemini.pfs.asunto.dto.DtoReportFaseComun;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.concursal.concurso.dto.DtoConcurso;
import es.pfsgroup.concursal.concurso.dto.DtoContratoConcurso;
import es.pfsgroup.concursal.credito.model.Credito;
import es.pfsgroup.concursal.credito.model.DDEstadoCredito;

@Component
public class ReportConcursoManager {

	// TIPOS DE CREDITO
	private static final String TIPO_CREDITO_CONTRA_MASA = "1";
	private static final String TIPO_CREDITO_PRIVILEGIADO_ESPECIAL = "2";
	private static final String TIPO_CREDITO_PRIVILEGIADO_GENERAL = "3";
	private static final String TIPO_CREDITO_ORDINARIO = "4";
	private static final String TIPO_CREDITO_SUBORDINARIO = "5";
	private static final String TIPO_CREDITO_NO_ADMITIDO = "6";
	private static final String TIPO_CREDITO_CONTINGENTE = "7";
	
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private UsuarioDao usuarioDao;

	@Resource
	Properties appProperties;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
    private Executor executor;
	
	/**
	 * Obtiene los cr�ditos de fase comun para el asunto
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de creditos insinuados
	 */
	@BusinessOperation(overrides = ReportAsuntoManager.GET_FASE_COMUN_ASUNTO_REPORT)
	public List<DtoReportFaseComun> obtenerFaseComun(Long idAsunto) {
	List<DtoReportFaseComun> listadoFaseComun = new ArrayList<DtoReportFaseComun>();
	
	List<DtoConcurso> lista = (List<DtoConcurso>) executor.execute("concursoManager.listadoFaseComun",idAsunto);

	if (!Checks.esNulo(lista)){
		for (DtoConcurso dtoLista : lista){
			
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
									if (cred.getTipoExterno().getCodigo().equals(TIPO_CREDITO_CONTRA_MASA))
										contraLetrado = contraLetrado + cred.getPrincipalExterno();
									else if (cred.getTipoExterno().getCodigo().equals(TIPO_CREDITO_PRIVILEGIADO_GENERAL))
										generalLetrado = generalLetrado + cred.getPrincipalExterno();
									else if (cred.getTipoExterno().getCodigo().equals(TIPO_CREDITO_PRIVILEGIADO_ESPECIAL))
										especialLetrado = especialLetrado + cred.getPrincipalExterno();
									else if (cred.getTipoExterno().getCodigo().equals(TIPO_CREDITO_ORDINARIO))
										ordinarioLetrado = ordinarioLetrado + cred.getPrincipalExterno();
									else if (cred.getTipoExterno().getCodigo().equals(TIPO_CREDITO_SUBORDINARIO))
										subordinarioLetrado = subordinarioLetrado + cred.getPrincipalExterno();
									else if (cred.getTipoExterno().getCodigo().equals(TIPO_CREDITO_NO_ADMITIDO))
										noAdmLetrado = noAdmLetrado + cred.getPrincipalExterno();	
									else if (cred.getTipoExterno().getCodigo().equals(TIPO_CREDITO_CONTINGENTE))
										contingenteLetrado = contingenteLetrado + cred.getPrincipalExterno();	
								}
								
								if(!Checks.esNulo(cred.getPrincipalDefinitivo()) && !Checks.esNulo(cred.getTipoDefinitivo())){
									if (cred.getTipoDefinitivo().getCodigo().equals(TIPO_CREDITO_CONTRA_MASA))
										contraFinal = contraFinal + cred.getPrincipalDefinitivo();
									else if (cred.getTipoDefinitivo().getCodigo().equals(TIPO_CREDITO_PRIVILEGIADO_GENERAL))
										generalFinal = generalFinal + cred.getPrincipalDefinitivo();
									else if (cred.getTipoDefinitivo().getCodigo().equals(TIPO_CREDITO_PRIVILEGIADO_ESPECIAL))
										especialFinal = especialFinal+ cred.getPrincipalDefinitivo();
									else if (cred.getTipoDefinitivo().getCodigo().equals(TIPO_CREDITO_ORDINARIO))
										ordinarioFinal = ordinarioFinal + cred.getPrincipalDefinitivo();
									else if (cred.getTipoDefinitivo().getCodigo().equals(TIPO_CREDITO_SUBORDINARIO))
										subordinarioFinal = subordinarioFinal + cred.getPrincipalDefinitivo();
									else if (cred.getTipoDefinitivo().getCodigo().equals(TIPO_CREDITO_NO_ADMITIDO))
										noAdmFinal = noAdmFinal + cred.getPrincipalDefinitivo();	
									else if (cred.getTipoDefinitivo().getCodigo().equals(TIPO_CREDITO_CONTINGENTE))
										contingenteFinal = contingenteFinal + cred.getPrincipalDefinitivo();
								}
								
							}
						}
					}
				}
				
				DtoReportFaseComun dto = new DtoReportFaseComun();
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
	
	/**
	 * Obtiene los contratos de un concurso
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de contratos
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation(overrides = ReportAsuntoManager.GET_CONTRATOS_ASUNTO_REPORT)
	public List<DtoReportContrato> obtenerContratos(Long idAsunto) {
		
		List<DtoReportContrato> listadoContratos = new ArrayList<DtoReportContrato>();
		StringBuffer insinuacionFinal = new StringBuffer();
		StringBuffer principalFinal = new StringBuffer();
		StringBuffer estadoCreditos = new StringBuffer();
		DecimalFormat monedaDecimalFormat = new DecimalFormat(FormatUtils.FORMATO_MONEDA + " " + FormatUtils.EURO);

		List<DtoConcurso> lista = (List<DtoConcurso>) executor.execute("concursoManager.listadoFaseComun",idAsunto);

		if (!Checks.esNulo(lista)){
			for (DtoConcurso dtoLista : lista){
				
				List<DtoContratoConcurso> listContratosConcurso = dtoLista.getContratos();

				if (!Checks.esNulo(listContratosConcurso)){
					for (DtoContratoConcurso dtoContConc : listContratosConcurso){
						
						DtoReportContrato dtoFinal = new DtoReportContrato();
						dtoFinal.setContrato(dtoContConc.getContrato());
						
						insinuacionFinal = new StringBuffer();
						principalFinal = new StringBuffer();
						estadoCreditos = new StringBuffer();
						
						List<Credito> listCreditos = dtoContConc.getCreditos();
						if(!Checks.esNulo(listCreditos)){
							for (Credito cred : listCreditos){
								if (!Checks.esNulo(cred.getPrincipalDefinitivo()) && !Checks.esNulo(cred.getTipoDefinitivo())){
									
									if(insinuacionFinal.length() != 0) {
										insinuacionFinal.append("\n");
									}
									if(principalFinal.length() != 0) {
										principalFinal.append("\n");
									}
									if(estadoCreditos.length() != 0) {
										estadoCreditos.append("\n");
									}
									
									insinuacionFinal.append(cred.getTipoDefinitivo().getDescripcion());
									principalFinal.append(monedaDecimalFormat.format(cred.getPrincipalDefinitivo()));
									estadoCreditos.append(cred.getEstadoCredito().getDescripcion());
									
								}
							}
						}
							
						dtoFinal.setInsinuacionFinal(insinuacionFinal.toString());
						dtoFinal.setPrincipalFinal(principalFinal.toString());
						dtoFinal.setEstadoCreditos(estadoCreditos.toString());

						listadoContratos.add(dtoFinal);
					}
				}
				
			}
		}
		
		return listadoContratos;
	
	}
	

}
