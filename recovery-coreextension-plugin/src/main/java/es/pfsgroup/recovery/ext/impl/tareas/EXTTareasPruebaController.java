package es.pfsgroup.recovery.ext.impl.tareas;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;
import es.pfsgroup.recovery.ext.api.tareas.EXTTareasApi;

@Controller
public class EXTTareasPruebaController {

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@RequestMapping
	public String createTarea(@RequestParam(value = "codigoTipoEntidad", required = true) String codigoTipoEntidad, 
								@RequestParam(value = "idEntidad", required = true) Long idEntidad,
								@RequestParam(value ="subtipoTarea", required =true) String subtipoTarea,
								@RequestParam(value ="usuario", required=true) Long idUsuario,
			ModelMap map) {
				
		System.out.println("Entra a pruebas controller");
		DtoGenerarTarea dto = new DtoGenerarTarea();
		dto.setCodigoTipoEntidad(codigoTipoEntidad);
		dto.setIdEntidad(idEntidad);
		dto.setSubtipoTarea(subtipoTarea);
		dto.setDescripcion("Prueba controller "+new Date());
		dto.setEnEspera(true);
		dto.setEsAlerta(false);
		dto.setFecha(new Date());
		dto.setPlazo(new Long(1000000000));
		
		
		EXTDtoGenerarTareaIdividualizadaImpl extDto = new EXTDtoGenerarTareaIdividualizadaImpl();
		extDto.setDestinatario(idUsuario);
		extDto.setTarea(dto);
		extDto.setTipoCalculo(TipoCalculo.TODO);
		Long resp = 0L;
		try {
			 resp = proxyFactory.proxy(EXTTareasApi.class).crearTareaNotificacionIndividualizada(extDto);
		} catch (EXTCrearTareaException e) {
			e.printStackTrace();
		}
		return resp.toString();
	}
}
