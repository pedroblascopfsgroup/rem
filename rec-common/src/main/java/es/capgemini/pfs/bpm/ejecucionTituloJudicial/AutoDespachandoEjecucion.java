package es.capgemini.pfs.bpm.ejecucionTituloJudicial;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bpm.generic.BaseActionHandler;
import es.capgemini.pfs.bpm.generic.JBPMLeaveEventHandler;
import es.capgemini.pfs.procesosJudiciales.dao.JuzgadoDao;

/**
 * Handler que se ejecuta a la salida del nodo BPM ejecucionTituloJudicial.AutoDespachando.
 * @author pajimene
 */
@Component("ejecucionTituloJudicial.AutoDespachando")
public class AutoDespachandoEjecucion extends BaseActionHandler implements JBPMLeaveEventHandler {

    private static final long serialVersionUID = 1L;

    @Autowired
    private JuzgadoDao juzgadoDao;

    @Autowired
    private ProcedimientoManager procedimientoManager;

    /**
     * Override del método onLeave. Se ejecuta al salir del nodo
     */
    @Override
    public void onLeave() {
        Long nJuzgado = null;
        String nProcedimiento = null;
        Procedimiento procedimiento = getProcedimiento();

        Map<String, Map<String, String>> valores = processUtils.creaMapValores(procedimiento.getId());

        nJuzgado = Long.parseLong(valores.get("P16_AutoDespachando").get("nJuz"));
        nProcedimiento = valores.get("P16_AutoDespachando").get("nProc");

        //Modificamos los datos del procedimiento y lo guardamos
        procedimiento.setJuzgado(juzgadoDao.get(nJuzgado));
        procedimiento.setCodigoProcedimientoEnJuzgado(nProcedimiento);

        procedimientoManager.saveOrUpdateProcedimiento(procedimiento);
    }
}
