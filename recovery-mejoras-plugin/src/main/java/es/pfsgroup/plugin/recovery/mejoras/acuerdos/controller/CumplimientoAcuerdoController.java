package es.pfsgroup.plugin.recovery.mejoras.acuerdos.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;

@Controller
public class CumplimientoAcuerdoController {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@RequestMapping
	public String listaCumplimiento(@RequestParam(value ="idAcuerdo", required = true) final Long idAcuerdo, ModelMap map){
		
		MEJTrazaDto dto = new MEJTrazaDto() {
			@Override
			public long getUsuario() {
				return 0;
			}
			@Override
			public String getTipoUnidadGestion() {
				return DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO;
			}
			@Override
			public String getTipoEvento() {
				return MEJDDTipoRegistro.CODIGO_CUMPLIMIENTO_ACUERDO;
			}
			@Override
			public Map<String, Object> getInformacionAdicional() {
				// TODO Auto-generated method stub
				return null;
			}
			@Override
			public long getIdUnidadGestion() {
				return idAcuerdo;
			}
		};
		List<? extends MEJRegistroInfo> cumplimientos = proxyFactory.proxy(MEJRegistroApi.class).buscaTrazasEvento(dto);
		map.put("cumplimientos", cumplimientos);
		
		
		return "plugin/mejoras/acuerdos/listaCumplimientoJSON";
	}

}
