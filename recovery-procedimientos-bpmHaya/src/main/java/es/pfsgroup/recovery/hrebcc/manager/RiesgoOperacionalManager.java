package es.pfsgroup.recovery.hrebcc.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import sun.reflect.generics.visitor.Reifier;
import es.capgemini.pfs.contrato.dao.EXTContratoDao;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.hrebcc.api.RiesgoOperacionalApi;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.hrebcc.model.CntRiesgoOperacional;
import es.pfsgroup.recovery.hrebcc.model.DDRiesgoOperacional;
import es.pfsgroup.recovery.integration.bpm.DiccionarioDeCodigos;

@Service
public class RiesgoOperacionalManager implements RiesgoOperacionalApi {

	@Autowired
	EXTContratoDao contratoDao;
	
	@Autowired
	UtilDiccionarioApi utilDiccionario;
	
	@Autowired
	GenericABMDao genericDao;
	
	@Override
	public void ActualizarRiesgoOperacional(ActualizarRiesgoOperacionalDto dto) {
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
	public DDRiesgoOperacional ObtenerRiesgoOperacionalContrato(Long cntId) {
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
}
