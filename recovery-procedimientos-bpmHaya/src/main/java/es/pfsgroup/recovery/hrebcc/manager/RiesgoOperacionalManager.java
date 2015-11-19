package es.pfsgroup.recovery.hrebcc.manager;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.contrato.dao.EXTContratoDao;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.hrebcc.api.RiesgoOperacionalApi;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.hrebcc.model.DDRiesgoOperacional;
import es.pfsgroup.recovery.integration.bpm.DiccionarioDeCodigos;

public class RiesgoOperacionalManager implements RiesgoOperacionalApi {

	@Autowired
	EXTContratoDao contratoDao;
	
	@Autowired
	UtilDiccionarioApi utilDiccionario;
	
	@Override
	public void ActualizarRiesgoOperacional(ActualizarRiesgoOperacionalDto dto) {
		if (!Checks.esNulo(dto.getIdContrato())) && !Checks.esNulo(dto.getCodRiesgoOperacional())) {
			//Obtenemos el contrato enviado
			EXTContrato contrato = (EXTContrato)contratoDao.get(dto.getIdContrato());
			
			//Obtenemos el objeto del riesgo operacional
			DDRiesgoOperacional riesgoOperacional = (DDRiesgoOperacional)utilDiccionario.dameValorDiccionarioByCod(DDRiesgoOperacional.class, dto.getCodRiesgoOperacional());
			
			//Si tenemos ambos objetos actualizamos el contrato
			if (!Checks.esNulo(contrato) && !Checks.esNulo(riesgoOperacional)) {
				contrato.setRiesgoOperacional(riesgoOperacional);
				contratoDao.saveOrUpdate(contrato);
			}
		}
	}

}
