package es.pfsgroup.recovery.hrebcc.manager;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import sun.reflect.generics.visitor.Reifier;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.dao.EXTContratoDao;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.hrebcc.api.RiesgoOperacionalApi;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.hrebcc.model.CntRiesgoOperacional;
import es.pfsgroup.recovery.hrebcc.model.DDRiesgoOperacional;
import es.pfsgroup.recovery.hrebcc.model.Vencidos;

@Service
public class RiesgoOperacionalManager implements RiesgoOperacionalApi {

	@Autowired
	EXTContratoDao contratoDao;
	
	@Autowired
	UtilDiccionarioApi utilDiccionario;
	
	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	ProcedimientoManager procedimientoManager;
	
	@Override
	@Transactional
	public void actualizarRiesgoOperacional(ActualizarRiesgoOperacionalDto dto) {
		if (!Checks.esNulo(dto.getIdContrato()) && !Checks.esNulo(dto.getCodRiesgoOperacional())) {
			//Obtenemos el contrato enviado
			EXTContrato contrato = (EXTContrato)contratoDao.get(dto.getIdContrato());
			
			//Obtenemos el objeto del riesgo operacional
			DDRiesgoOperacional riesgoOperacional = (DDRiesgoOperacional)utilDiccionario.dameValorDiccionarioByCod(DDRiesgoOperacional.class, dto.getCodRiesgoOperacional());
			
			//Si tenemos ambos objetos actualizamos el contrato
			if (!Checks.esNulo(contrato) && !Checks.esNulo(riesgoOperacional)) {
				//Primero obtenemos la relación del contrato con algún riesgo operacional
				CntRiesgoOperacional cntRiesgo = genericDao.get(CntRiesgoOperacional.class, genericDao.createFilter(FilterType.EQUALS, "contrato.id", contrato.getId())
															,genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				if (!Checks.esNulo(cntRiesgo)) {
					//Si ya tiene uno lo borramos
					genericDao.deleteById(CntRiesgoOperacional.class, cntRiesgo.getId());
				}
				
				//Ahora creamos un nuevo registro
				cntRiesgo = new CntRiesgoOperacional();
				cntRiesgo.setContrato(contrato);
				cntRiesgo.setRiesgoOperacional(riesgoOperacional);
				
				genericDao.save(CntRiesgoOperacional.class, cntRiesgo);
			}
		}
	}
	
	@Override
	@BusinessOperation(overrides = PrimariaBusinessOperation.BO_CNT_MGR_GET_RIESGO)
	public DDRiesgoOperacional obtenerRiesgoOperacionalContrato(Long cntId) {
		DDRiesgoOperacional resultado = null;
		
		if (!Checks.esNulo(cntId)) {
			//Obtenemos el riesgo operacional del contrato
			CntRiesgoOperacional cntRiesgo = genericDao.get(CntRiesgoOperacional.class, genericDao.createFilter(FilterType.EQUALS, "contrato.id", cntId)
					,genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			
			if (!Checks.esNulo(cntRiesgo)) {
				//Si tiene un riesgo se devuelve
				resultado = cntRiesgo.getRiesgoOperacional();
			}
		}
		
		return resultado;
	}
	







	@Override
	@BusinessOperation(overrides = PrimariaBusinessOperation.BO_CNT_MGR_GET_VENCIDOS)
	public Vencidos obtenerVencidosByCntId(Long cntId){
		Vencidos resulVencidos = null;
		
		if(!Checks.esNulo(cntId)){
			Vencidos vencidos = genericDao.get(Vencidos.class, genericDao.createFilter(FilterType.EQUALS, "cntId", cntId));
			
			if(!Checks.esNulo(vencidos)){
				resulVencidos = vencidos;
			}
		}
		
		return resulVencidos;
	/**
	 * Comprobamos que todos los contratos del asunto del procedimiento tienen un riesgo operacional asociado
	 */
	@Override
	public Boolean comprobarRiesgoProcedimiento(Long idProcedimiento) {
		Boolean resultado = true;
		
		Procedimiento prc = procedimientoManager.getProcedimiento(idProcedimiento);
		if (Checks.esNulo(prc)) {
			resultado = false;
		} else {
			Set<Contrato> contratos = prc.getAsunto().getContratos();
			for (Contrato contrato : contratos) {
				if (Checks.esNulo(this.ObtenerRiesgoOperacionalContrato(contrato.getId()))) {
					resultado = false;
				}
			}
		}
		
		return resultado;
	}
}
