package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioContratoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonioContrato;
import es.pfsgroup.plugin.rem.model.DtoActivoPatrimonioContrato;
import es.pfsgroup.plugin.rem.model.DtoActivoVistaPatrimonioContrato;

@Component
public class TabActivoPatrimonioContrato implements TabActivoService {

	@Autowired
	private ActivoPatrimonioContratoDao activoPatrimonioDao;

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_PATRIMONIO_CONTRATO};
	}

	public DtoActivoPatrimonioContrato getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {
		DtoActivoPatrimonioContrato activoPatrimonioContratoDto = new DtoActivoPatrimonioContrato();		
		List<ActivoPatrimonioContrato> listActivoPatrimonioContrato = activoPatrimonioDao.getActivoPatrimonioContratoByActivo(activo.getId());
		DtoActivoVistaPatrimonioContrato activoVistaPatrimonioContratoDto = new DtoActivoVistaPatrimonioContrato();
		//List<ActivoVistaPatrimonioContrato> listActivosRelacionados = activoPatrimonioDao.getActivosRelacionados(activo.getId());
		
		if(!Checks.estaVacio(listActivoPatrimonioContrato)) {
			ActivoPatrimonioContrato activoPatrimonioContrato = listActivoPatrimonioContrato.get(0);
			if(!Checks.esNulo(activoPatrimonioContrato.getEstadoContrato())) {
				BeanUtils.copyProperties(activoPatrimonioContratoDto, activoPatrimonioContrato);
				if(!Checks.esNulo(activoPatrimonioContrato.getActivo())) {
					activoPatrimonioContratoDto.setIdActivo(activoPatrimonioContrato.getActivo().getId());
				}
			}	
			activoPatrimonioContratoDto.setMultiplesResultados(listActivoPatrimonioContrato.size() > 1);

		}
		
		
		return activoPatrimonioContratoDto;
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto dto) {
		// TODO Auto-generated method stub
		return null;
	}
}
