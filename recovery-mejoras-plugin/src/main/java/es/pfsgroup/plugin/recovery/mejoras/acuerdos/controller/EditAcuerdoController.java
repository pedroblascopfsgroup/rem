package es.pfsgroup.plugin.recovery.mejoras.acuerdos.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.core.api.acuerdo.AcuerdoApi;
import es.capgemini.pfs.core.api.acuerdo.CumplimientoAcuerdoDto;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoApi;

@Controller 
public class EditAcuerdoController {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@RequestMapping
	public String open(@RequestParam(value = "idAcuerdo", required = true) Long id, ModelMap map) {
				
		Acuerdo acuerdo = proxyFactory.proxy(AcuerdoApi.class).getAcuerdoById(id);
		map.put("acuerdo",acuerdo);
		
		return "plugin/mejoras/acuerdos/cumplimientoAcuerdo";
	}
	
	@RequestMapping
	public String guardaCumplimientoAcuerdo(WebRequest request){
		CumplimientoAcuerdoDto dto = creaDto (request);
		
		if (dto.getFinalizar()){
			proxyFactory.proxy(AcuerdoApi.class).cerrarAcuerdo(dto.getId());
		}
		if (!dto.getFinalizar()){
//			proxyFactory.proxy(AcuerdoApi.class).continuarAcuerdo(dto.getId());
			proxyFactory.proxy(MEJAcuerdoApi.class).continuarAcuerdo(dto.getId());
		}
		proxyFactory.proxy(AcuerdoApi.class).registraCumplimientoAcuerdo(dto);
		return "default";
	}

	private CumplimientoAcuerdoDto creaDto(final WebRequest request) {
		return DynamicDtoUtils.create(CumplimientoAcuerdoDto.class, request);
	}

}
