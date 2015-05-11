package es.pfsgroup.recovery.ext.impl.utils;

import java.util.Date;
import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.recovery.api.JBPMProcessApi;

public abstract class EXTBaseJBPMProcessManager implements JBPMProcessApi{

	@Override
	public void addVariablesToProcess(Long arg0, Map<String, Object> arg1) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void aplazarProcesosBPM(Long arg0, Date arg1) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void creaORecalculaTimer(Long arg0, String arg1, Date arg2,
			String arg3) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Procedimiento creaProcedimientoHijo(TipoProcedimiento arg0,
			Procedimiento arg1) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public long crearNewProcess(String arg0, Map<String, Object> arg1) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void destroyProcess(Long arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Object evaluaScript(Long arg0, Long arg1, Long arg2,
			Map<String, Object> arg3, String arg4) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void finalizarProcedimiento(Long arg0) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public String getActualNode(Long arg0) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Boolean getFixeBooleanValue(ExecutionContext arg0, String arg1) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Object getVariablesToProcess(Long arg0, String arg1) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Long lanzaBPMAsociadoAProcedimiento(Long arg0, Long arg1) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Date obtenerFechaFinProceso(Long arg0, String arg1) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void recalculaTimer(Long arg0, String arg1, Date arg2) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void signalProcess(Long arg0, String arg1) {
		// TODO Auto-generated method stub
		
	}

}
