package es.capgemini.pfs.web.testBpm;

import java.util.HashMap;

import org.jbpm.JbpmContext;
import org.jbpm.graph.exe.Token;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springmodules.workflow.jbpm31.JbpmCallback;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.bpm.ProcessManager;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.utils.JBPMProcessManager;

@Service
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = false)
public class TestBPMManager {

    @Autowired
    private JBPMProcessManager jbpmManager;

    @Autowired
    private ProcessManager processManager;

    @Autowired
    TareaExternaManager tareaExternaManager;

    @Autowired
    ProcedimientoManager procedimientoManager;

    @Transactional(readOnly = false)
    @BusinessOperation
    public void destroyProcess(Long idProcedimiento) {
        jbpmManager.destroyProcess(idProcedimiento);
    }

    @BusinessOperation
    public Long creaBPM(Long idProcedimiento) {
        jbpmManager.determinarBBDD();

        HashMap<String, Object> param = new HashMap<String, Object>();

        Procedimiento procedimiento = procedimientoManager.getProcedimiento(idProcedimiento);

        param.put(BPMContants.PROCEDIMIENTO_TAREA_EXTERNA, idProcedimiento);
        return jbpmManager.crearNewProcess(procedimiento.getTipoProcedimiento().getXmlJbpm(), param);
    }

    @BusinessOperation
    public void signal(Long idToken, String transitionName) {
        jbpmManager.signalToken(idToken, transitionName);
    }

    @BusinessOperation
    public TareaExterna getTareaExterna(Long idToken) {
        return tareaExternaManager.obtenerTareaPorToken(idToken);
    }

    @BusinessOperation
    public Token getToken(final Long idToken) {
        processManager.execute(new JbpmCallback() {
            @Override
            public Object doInJbpm(JbpmContext context) {
                // Obtener la Ãºltima instancia conocida
                return context.getGraphSession().getToken(idToken);
            }
        });
        return null;
    }

}
