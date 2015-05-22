package es.pfsgroup.procedimientos.context.api;

import java.util.List;


/**
 * API con las operaciones de negocio para Editar Bienes.
 *
 */
public interface ProcedimientosProjectContext {
	
	public float getLimiteDeudaGlobal();
	public float getLimiteDeudaBien();
	public String getTipoSubastaSareb();
	public List<String> getTiposSubasta();
	public List<String> getTareasCelebracionSubasta();
	public List<String> getTareasSenyalamientoSubastas();
	public List<String> getCamposCostas();
	public List<String> getCamposSuspensionSubasta();
	public String getCodigoCargaAnterior();
	
}
