package es.pfsgroup.procedimientos.adjudicacion;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.bpm.ProcessManager;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdicionalBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;

/**
 *
 */
@Service("adjudicacionHayaProcedimientoManagerDelegated")
public class AdjudicacionHayaProcedimientoManager {

	private static final String BO_ADJUDICACION_VALIDAR_ADJUNTO_SAREB = "es.pfsgroup.recovery.adjudicacion.validarAdjuntoSareb";

	private static final String TIPO_CARGA_ANTERIOR_HIPOTECA = "ANT";

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;

	@Autowired
	private ProcessManager processManager;
	
	@Autowired
	private GenericABMDao genericDao;


 	
	@BusinessOperation(BO_ADJUDICACION_VALIDAR_ADJUNTO_SAREB)
	public String validarAdjuntoSareb(Long prcId)  {
	
		String tipoAdj = new String();
		String tipoTextoValidacion = null;
		String prcPadre = new String();

		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);
		
		Set<AdjuntoAsunto> adjuntos = prc.getAdjuntos();
		
		prcPadre = prc.getProcedimientoPadre().getNombreProcedimiento().split("-")[1];

		if (prcPadre.contains("aneamiento") && prcPadre.contains("argas")) {
			//T. Saneamiento Cargas
			tipoAdj = "RSPCCA";
		} else if (prcPadre.contains("ropuesta") && prcPadre.contains("nticipada") && prcPadre.contains("onvenio")) {
			//T. Propuesta Anticipada Convenio
			tipoAdj = "RSIPAC";
		} else if (prcPadre.contains("ase") && prcPadre.contains("iquidaci")) {
			//T. Fase Liquidacion
			tipoAdj = "RSPPAL";
		} else if (prcPadre.contains("jecuci") && prcPadre.contains("otarial")) {
			//T. Ejecucion Notarial
			tipoAdj = "RSANSU";
		} else if (prcPadre.contains("omologaci") && prcPadre.contains("cuerdo")) {
			//T. Homologacion de Acuerdo
			tipoAdj = "RSINPA";
		} else if(prcPadre.contains("emandado") && prcPadre.contains("ncidente")){
			tipoAdj = "RSISDI";
		}
		
		for (AdjuntoAsunto adjunto : adjuntos) {
			if (!Checks.esNulo(adjunto.getProcedimiento()) && adjunto.getProcedimiento().getId() == prcId) {
				if (adjunto instanceof EXTAdjuntoAsunto) {
					if (tipoAdj.equals(((EXTAdjuntoAsunto) adjunto).getTipoFichero().getCodigo())) {
						return null;
					} 
				}
			}
		}

		if (tipoAdj.equals("RSPCCA")) {
			tipoTextoValidacion = "Es necesario adjuntar el documento Respuesta Sareb sobre propuesta de cancelacion de cargas.";
		} else if (tipoAdj.equals("RSIPAC")) {
			tipoTextoValidacion = "Es necesario adjuntar el documento Respuesta Sareb con Instrucciones sobre Propuesta Anticipada Convenio.";
		} else if (tipoAdj.equals("RSPPAL")) {
			tipoTextoValidacion = "Es necesario adjuntar el documento Respuesta Sareb sobre propuesta de alegaciones.";
		} else if (tipoAdj.equals("RSANSU")) {
			tipoTextoValidacion = "Es necesario adjuntar el documento Respuesta Sareb sobre anuncio de la subasta.";
		} else if (tipoAdj.contains("RSINPA")) {
			tipoTextoValidacion = "Es necesario adjuntar el documento Respuesta Sareb con Instrucciones sobre la Propuesta de Acuerdo.";
		} else if (tipoAdj.contains("RSISDI")) {
			tipoTextoValidacion = "Es necesario adjuntar el documento Respuesta Sareb con Instrucciones sobre Demanda Incidental.";
		}
		
		return tipoTextoValidacion;

	}
	
	
	@BusinessOperation("es.pfsgroup.recovery.adjudicacion.obtenerTipoCargaBien")
	public String obtenerTipoCargaBien(Long prcId) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null || (cargas != null && cargas.size() == 0)) {
						return "noCargas";
					} else {
						// hay cargas
						boolean hayRegistrales = false;
						boolean hayEconomicas = false;
						for (NMBBienCargas carga : cargas) {
							if (carga.getRegistral() && !Checks.esNulo(carga.getSituacionCarga()) && DDSituacionCarga.ACEPTADA.compareTo(carga.getSituacionCarga().getCodigo()) == 0) {
								//Solo se activa la marca si la carga es registral y está activa
								hayRegistrales = true;
							}
							if (carga.isEconomica() && !Checks.esNulo(carga.getSituacionCargaEconomica()) && DDSituacionCarga.ACEPTADA.compareTo(carga.getSituacionCargaEconomica().getCodigo()) == 0) {
								//Solo se activa la marca si la carga es económica y está activa
								hayEconomicas = true;
							}
						}
						if (hayRegistrales) {
							if(hayEconomicas){
								return "ambos";
							} else {
								return "registrales";
							}
						} else {
							if (hayEconomicas){
								return "economicas";
							} else {
								//Aun habiendo cargas, se descartan si no hay activas
								return "noCargas";
							}
								
						}
					}
				}
			}
		}
		return null;
	}
	
	
	public Boolean comprobarTipoCargaBienIns(Long prcId) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null || (cargas != null && cargas.size() == 0)) {
						NMBAdicionalBien adicionalBien = ((NMBBien) bien).getAdicional();
						// y se ha revisado
						if (adicionalBien.getSinCargas() != null && adicionalBien.getSinCargas()) {
							return true;
						} else {
							return false;
						}
					} else {
						// hay cargas
						Boolean verificadasCargas = false;
						for (NMBBienCargas carga : cargas) {
							if (carga.getRegistral() && carga.getRegistral() != null && carga.getSituacionCarga() != null) {
								verificadasCargas = true;
							} else 	if (carga.isEconomica() && carga.getSituacionCargaEconomica() != null) {
								verificadasCargas = true;
							} else {
								return false;
							}
						}
						if (verificadasCargas) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	public Boolean existenCargasPreviasActivas(Long prcId) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		Boolean verificadasCargas = false;
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					for (NMBBienCargas carga : cargas) {
						if (!carga.getTipoCarga().getCodigo().equals(TIPO_CARGA_ANTERIOR_HIPOTECA)) {
							continue;
						}
						if ( (carga.getSituacionCarga()!=null && carga.getSituacionCarga().getCodigo().equals(DDSituacionCarga.ACEPTADA))
							||
							 (carga.getSituacionCargaEconomica()!=null && carga.getSituacionCargaEconomica().getCodigo().equals(DDSituacionCarga.ACEPTADA))
							) {
							verificadasCargas=true;
							break;
						}
					}
				}
				if (verificadasCargas) {
					break;
				}
			}
		}
		return verificadasCargas;
	}
	
}
