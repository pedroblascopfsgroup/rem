package es.capgemini.pfs.expediente.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.pfs.cliente.process.ClienteBPMConstants;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.exceptions.NonRollbackException;
import es.capgemini.pfs.expediente.ExpedienteManager;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * Handler del Nodo Crear Expediente.
 * @author jbosnjak
 *
 */
@Component
public class CrearExpedienteActionHandler extends JbpmActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private JBPMProcessManager jbpmUtils;

    @Autowired
    private ExpedienteManager expedienteManager;

    private static final long serialVersionUID = 1L;

    /**
     * Este metodo debe llamar a la creacion del expediente.
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("CrearExpedienteActionHandler......");
        }
        //Invocar a la creación del expediente
        Long idBPMExpediente = executionContext.getProcessInstance().getId();
        logger.debug("Id de proceso creado: " + idBPMExpediente);
        Long idContrato = (Long) executionContext.getVariable(CONTRATO_ID);
        Long idBPMCliente = (Long) executionContext.getVariable(IDBPMCLIENTE);
        Long idArquetipo = (Long) executionContext.getVariable(ARQUETIPO_ID);
        Long expedienteManualId = (Long) executionContext.getVariable(EXPEDIENTE_MANUAL_ID);

        Long idPersona = (Long) executionContext.getVariable(ClienteBPMConstants.PERSONA_ID);
        if (idPersona == null) idPersona = (Long) jbpmUtils.getVariablesToProcess(idBPMCliente, ClienteBPMConstants.PERSONA_ID);

        if (expedienteManualId != null) {
            logger.debug("Entre por Expediente Manual");
            executionContext.setVariable(EXPEDIENTE_ID, expedienteManualId);
            executionContext.setVariable(ARQUETIPO_ID, expedienteManager.getExpediente(expedienteManualId).getArquetipo().getId());
        } else {
            try {
                Expediente expediente = expedienteManager
                        .crearExpedienteAutomatico(idContrato, idPersona, idArquetipo, idBPMExpediente, idBPMCliente);
                executionContext.setVariable(EXPEDIENTE_ID, expediente.getId());
            } catch (GenericRollbackException e) {
                logger.error("Error al crear un expediente para el contrato " + idContrato, e);
                logger.info("Se finaliza el proceso BPM de Expedientes porque no se pudo crear el mismo");
                executionContext.getProcessInstance().end();
                return;
            } catch (NonRollbackException be) {
                logger.info("Ya existe el expediente para el contrato " + idContrato + ", se anula el proceso BPM. " + be.getMessage());
                executionContext.getProcessInstance().end();
                return;
            }

        }
        executionContext.getProcessInstance().signal();
    }
}
