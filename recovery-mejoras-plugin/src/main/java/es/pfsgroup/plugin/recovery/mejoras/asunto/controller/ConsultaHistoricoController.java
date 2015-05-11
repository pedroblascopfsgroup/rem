package es.pfsgroup.plugin.recovery.mejoras.asunto.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;

@Controller
public class ConsultaHistoricoController {
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Autowired
	GenericABMDao genericDao;
	
	
	@RequestMapping
	public String consultarHistoricoAutoprorroga(@RequestParam(value="id", required=true)Long id, ModelMap map){
		
		Map<String, String> infoRegistro= proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(id);
		map.put("infoRegistro", infoRegistro);
		
		return "plugin/mejoras/procedimientos/formulario/vistaAutoProrroga";
	}
	
	@RequestMapping
	public String consultarHistoricoRecursoRevisado(@RequestParam(value="id", required=true)Long id, ModelMap map){
		
		Map<String, String> infoRegistro= proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(id);
		map.put("infoRegistro", infoRegistro);
		
		return "plugin/mejoras/procedimientos/formulario/vistaRecursoRevisado";
	}
	
	@RequestMapping
	public String consultarEnvioEmailGestor(@RequestParam(value="id", required=true)Long id, ModelMap map){
		Map<String, String> infoRegistro= proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(id);
		map.put("infoRegistro", infoRegistro);
		
		return "plugin/mejoras/procedimientos/formulario/vistaHistoricoMail";
	}
	
	@RequestMapping
	public String consultarModificarCabeceraProcedimiento(@RequestParam(value="id", required=true)Long id, ModelMap map){
		Map<String, String> infoRegistro= proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(id);
		map.put("infoRegistro", infoRegistro);
		if (!Checks.esNulo(infoRegistro.get("juzNew"))){
			if (!Checks.esNulo(infoRegistro.get("juzOld"))){
				Filter idJuzgadoOld = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(infoRegistro.get("juzOld")));
				TipoJuzgado jOld = genericDao.get(TipoJuzgado.class, idJuzgadoOld);
				map.put("descJuzOld", jOld.getDescripcion());
				map.put("descPlazaOld", jOld.getPlaza().getDescripcion());
			}
			
			Filter idJuzgadoNew = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(infoRegistro.get("juzNew")));
			TipoJuzgado jNew = genericDao.get(TipoJuzgado.class, idJuzgadoNew);
		
			map.put("descJuzNew", jNew.getDescripcion());
			map.put("descPlazaNew", jNew.getPlaza().getDescripcion());
			
		}
		if (!Checks.esNulo(infoRegistro.get("treNew"))){
			Filter idTipoRecOld = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(infoRegistro.get("treOld")));
			DDTipoReclamacion tipoReclOld = genericDao.get(DDTipoReclamacion.class, idTipoRecOld);
			Filter idTipoRecNew = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(infoRegistro.get("treNew")));
			DDTipoReclamacion tipoReclNew = genericDao.get(DDTipoReclamacion.class, idTipoRecNew);
			
			map.put("descTreOld", tipoReclOld.getDescripcion());
			map.put("descTreNew", tipoReclNew.getDescripcion());
			
		}
		
		return "plugin/mejoras/procedimientos/formulario/vistaModificacionProcedimiento";
	}


}
