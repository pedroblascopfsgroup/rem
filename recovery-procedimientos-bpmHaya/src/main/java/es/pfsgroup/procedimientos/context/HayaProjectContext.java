package es.pfsgroup.procedimientos.context;

import java.util.List;

public interface HayaProjectContext {

	public List<String> getTareasInicioConcursal();

	public List<String> getTareasInicioLitigios();

	public String getTareaAceptacionLitigios();
	
	public String getCodigoHipotecario();

	public String getCodigoMonitorio();

	public String getCodigoOrdinario();
	
	public String getCodigoTareaDemandaHipotecario();
	
	public String getCodigoTareaDemandaMonitorio();
	
	public String getCodigoTareaDemandaOrdinario();
	
	public String getFechaDemandaHipotecario();
	
	public String getFechaDemandaMonitorio();
	
	public String getFechaDemandaOrdinario();

	public String getTareaInicioConcurso();

}