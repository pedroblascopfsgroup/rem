package es.pfsgroup.plugin.recovery.mejoras.test.procedimiento.MEJProcedimientoManager;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.MEJProcedimientoManager;

public class MEJProcedimientoManagerParaTestear extends MEJProcedimientoManager{

    @Override
    public void cambiarGestorSupervisorTramiteSubasta(Procedimiento proc) {
        super.cambiarGestorSupervisorTramiteSubasta(proc);
    }

}
