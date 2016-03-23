package es.pfsgroup.plugin.recovery.mejoras.acuerdos.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.AcuerdoProcedimientoApi;

@Component
public class AcuerdoProcedimientoManager extends BusinessOperationOverrider<AcuerdoProcedimientoApi> implements AcuerdoProcedimientoApi {
	
	@Autowired
	private ProcedimientoDao procedimientoDao;
	
	@Override
	public String managerName() {
		return "acuerdoProcedimientoManager";
	}
	
	/**
     * Indica si el Usuario Logado puede ver la pestaña recursos.
     * @param idProcedimiento el id del procedimiento.
     * @return true o false.
     */
	@BusinessOperation(BO_ACU_PRC_VER_TAB_RECURSOS)
    public boolean verTabRecursos(Long idProcedimiento) {

		Procedimiento proc = procedimientoDao.get(idProcedimiento);
		String codigo = proc.getTipoActuacion().getCodigo();
		
		if (!Checks.esNulo(codigo)){
			if(codigo.equals("ACU")){
				return false;
			}
		}
		return true;
    }

	/**
     * Recupera el codigo de actuacion de un procedimiento para el filtrado
     * @param idProcedimiento el id del procedimiento.
     * @return codigo.
     */
	@BusinessOperation(BO_ACU_PRC_CODIGO_TIPO_ACTUACION)
    public String codigoTipoActuacion(Long idProcedimiento) {

		Procedimiento proc = procedimientoDao.get(idProcedimiento);
		String codigo = proc.getTipoActuacion().getCodigo();
		if (!Checks.esNulo(codigo)){
			return codigo;
		}
		return null;
    }
	
	/**
     * Indica si el Usuario Logado puede ver la pestaña Información Requerida.
     * @param idProcedimiento el id del procedimiento.
     * @return true o false.
     */
	//CAMBIAR EN EL ITEM PRODUCTO-1046 TODO
	@BusinessOperation(BO_ACU_PRC_VER_TAB_INF_REQUERIDA)
    public boolean verTabInfRequerida(Long idProcedimiento) {

		Procedimiento proc = procedimientoDao.get(idProcedimiento);
		String codigo = proc.getTipoActuacion().getCodigo();
		
		if (!Checks.esNulo(codigo)){
			if(codigo.equals("ACU")){
				return false;
			}
		}
		return false;
    }

}
