package es.pfsgroup.plugin.recovery.mejoras.test.decisionProcedimiento.MEJDecisionProcedimientoManager;

import java.util.ArrayList;

import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;

/**
 * Factor�a para generar dtos de tipo {@link MEJDtoDecisionProcedimiento}
 * 
 * @author bruno
 * 
 */
public class MEJDtoDecisionProcedimientoTestFactory {

    /**
     * Crea un DTO que hace referencia a una Decisi�nExistente.
     * 
     * @param idDecisionProcedimiento
     * @param idProcedimiento
     * @return
     */
    public static MEJDtoDecisionProcedimiento decisionExistente(Long idDecisionProcedimiento, Long idProcedimiento) {
        //return createDto(idProcedimiento, idDecisionProcedimiento, null, null, null);
        return createDto(idProcedimiento, idDecisionProcedimiento, null, null, null, null);
    }

    /**
     * Crea un DTO que hace referencia a una Decisi�nExistente con la derivaci�n
     * de procedimientos.
     * 
     * @param idDecisionProcedimiento
     * @param idProcedimiento
     * @param idsPrcDerivar
     * @return
     */
    public static MEJDtoDecisionProcedimiento decisionExistenteDerivacion(Long idDecisionProcedimiento, Long idProcedimiento, Long[] idsPrcDerivar) {
        //return createDto(idProcedimiento, idDecisionProcedimiento, null, idsPrcDerivar, null);
        return createDto(idProcedimiento, idDecisionProcedimiento, null, idsPrcDerivar, null, null);
    }

    /**
     * Devuelve un DTO para crear una nueva decisi�n.
     * 
     * @param estadoDecision
     * @param causaDecision 
     * @param idProcedimiento
     * @param derivadosId 
     * 
     * @return
     */
    //public static MEJDtoDecisionProcedimiento nuevaDecision(String estadoDecision, String causaDecision, Long idProcedimiento, Long[] derivadosId) {
    public static MEJDtoDecisionProcedimiento nuevaDecision(String estadoDecision, String causaDecisionFinalizar, String causaDecisionParalizar, Long idProcedimiento, Long[] derivadosId) {
        return createDto(idProcedimiento, null, estadoDecision, derivadosId, causaDecisionFinalizar, causaDecisionParalizar);
    	
        //return createDto(idProcedimiento, null, estadoDecision, derivadosId, causaDecision);
    }

    /**
     * Crea el dto b�sico para el caso de test.
     * 
     * @param idProcedimiento
     *            Id del procedimiento
     * @param idDecisionProcedimiento
     *            Id de la DecisionProcedimiento.
     * @param estadoDecision
     * @param derivadosId
     *            Id's de los procedimientos derivados que contiene la
     *            propuesta. Si se pasa NULL o un array vac�o se supondr� que no
     *            se quiere derivar en ning�n procedimiento
     * @param causaDecision 
     * @return
     */
    //private static MEJDtoDecisionProcedimiento createDto(Long idProcedimiento, Long idDecisionProcedimiento, String estadoDecision, final Long[] derivadosId, String causaDecision) {
    private static MEJDtoDecisionProcedimiento createDto(Long idProcedimiento, Long idDecisionProcedimiento, String estadoDecision, final Long[] derivadosId, String causaDecisionFinalizar, String causaDecisionParalizar) {    

        final DecisionProcedimiento decisionProcedimiento = new DecisionProcedimiento();
        decisionProcedimiento.setId(idDecisionProcedimiento);

        final MEJDtoDecisionProcedimiento dto = new MEJDtoDecisionProcedimiento();
        dto.setIdProcedimiento(idProcedimiento);
        dto.setDecisionProcedimiento(decisionProcedimiento);
        //dto.setCausaDecision(causaDecision);
        dto.setCausaDecisionFinalizar(causaDecisionFinalizar);
        dto.setCausaDecisionParalizar(causaDecisionParalizar);        

        if (!Checks.esNulo(estadoDecision)) {
            dto.setStrEstadoDecision(estadoDecision);
        }

        if (derivadosId != null) {
            final ArrayList<DtoProcedimientoDerivado> derivados = new ArrayList<DtoProcedimientoDerivado>();
            DtoProcedimientoDerivado dtopd;
            for (int i = 0; i < derivadosId.length; i++) {
                dtopd = new DtoProcedimientoDerivado();
                dtopd.setProcedimientoPadre(idProcedimiento);
                dtopd.setId(derivadosId[i]);
                derivados.add(dtopd);
            }
            dto.setProcedimientosDerivados(new ArrayList<DtoProcedimientoDerivado>());
        }

        return dto;
    }

}
