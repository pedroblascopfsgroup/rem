package es.pfsgroup.recovery.recobroConfig.metasVolantes.controller.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroEsquemaApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dto.RecobroDtoItinerario;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dto.RecobroDtoMetaVolante;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.manager.api.RecobroItinerarioApi;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroItinerarioMetasVolantes;
import es.pfsgroup.recovery.recobroConfig.metasVolantes.controller.api.RecobroItinerarioControllerApi;

@Controller
public class RecobroItinerarioController implements RecobroItinerarioControllerApi{

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String abreABMItinerariosRecobro(ModelMap map) {
		List<RecobroEsquema> listaEsquemas = proxyFactory.proxy(RecobroEsquemaApi.class).getListaEsquemas();
		List<RecobroDDEstadoComponente> ddEstado = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDEstadoComponente.class);
		
		map.put("listaEsquemas", listaEsquemas);
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION);
		map.put("ESTADO_BLOQUEADO", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
		map.put("ESTADO_DISPONIBLE",  RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		map.put("ddEstado", ddEstado);
		
		return "plugin/recobroConfig/metasVolantes/recobroListaItinerarios";
	}

	@SuppressWarnings("unchecked")
	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String buscaItinerariosRecobro(RecobroDtoItinerario dto, ModelMap map) {
		Page itinerarios = proxyFactory.proxy(RecobroItinerarioApi.class).buscaItinerarios(dto);
		
		map.put("listaItinerarios", itinerarios);
		return "plugin/recobroConfig/metasVolantes/recobroListaItinerariosJSON";

	}

	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String altaItinerarioRecobro(ModelMap map) {
		
		return "plugin/recobroConfig/metasVolantes/recobroAltaItinerario" ;
		
	}
	
	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String editaItinerarioRecobro(RecobroDtoItinerario dto, ModelMap map) {
		
		RecobroItinerarioMetasVolantes itinerario = proxyFactory.proxy(RecobroItinerarioApi.class).getItinerarioRecobro(Long.valueOf(dto.getId()));
		map.put("itinerario", itinerario);
		
		return "plugin/recobroConfig/metasVolantes/recobroAltaItinerario" ;
		
	}

	@SuppressWarnings("unchecked")
	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String guardaItinerarioRecobro(RecobroDtoItinerario dto, ModelMap map) {
		
		Long idItinerario = proxyFactory.proxy(RecobroItinerarioApi.class).guardaItinerarioRecobro(dto);
		
		RecobroItinerarioMetasVolantes itinerario = proxyFactory.proxy(RecobroItinerarioApi.class).getItinerarioRecobro(idItinerario);
		map.put("itinerario", itinerario);
		
		return "plugin/recobroConfig/metasVolantes/recobroItinerarioJSON";
	}

	@SuppressWarnings("unchecked")
	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String openItinerarioRecobro(RecobroDtoItinerario dto, ModelMap map) {
		
		RecobroItinerarioMetasVolantes itinerario = proxyFactory.proxy(RecobroItinerarioApi.class).getItinerarioRecobro(Long.valueOf(dto.getId()));
		map.put("itinerario", itinerario);
		
		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
		map.put("fechaAltaFormateada", format.format(itinerario.getFechaAlta()));
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		map.put("usuarioLogado", usuarioLogado);
		map.put("ESTADO_DEFINICION", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION);
		map.put("ESTADO_BLOQUEADO", RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO);
		map.put("ESTADO_DISPONIBLE",  RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		
		return "plugin/recobroConfig/metasVolantes/recobroListaMetas" ;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String getMetasItinerario(RecobroDtoItinerario dto, ModelMap map) {
		
		List listaMetas = proxyFactory.proxy(RecobroItinerarioApi.class).buscaMetasPorItinerario(Long.valueOf(dto.getId()));
		map.put("listaMetas", listaMetas);
		
		return "plugin/recobroConfig/metasVolantes/recobroListaMetasJSON" ;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String editaMetasVolantes(RecobroDtoItinerario dto, ModelMap map) {
		
		List listaMetas = proxyFactory.proxy(RecobroItinerarioApi.class).buscaMetasPorItinerario(Long.valueOf(dto.getId()));
		map.put("listaMetas", listaMetas);
		map.put("idItinerario", dto.getId());
		map.put("nombreItinerario", dto.getNombre());
		
		RecobroItinerarioMetasVolantes itinerario = proxyFactory.proxy(RecobroItinerarioApi.class).getItinerarioRecobro(Long.valueOf(dto.getId()));
		if (!Checks.esNulo(itinerario)){
			map.put("plazoMaxGestion", itinerario.getPlazoMaxGestion());
			map.put("plazoSinGestion", itinerario.getPlazoSinGestion());
		}
		
		List<DDSiNo> ddsino = proxyFactory.proxy(DiccionarioApi.class).getDDsino();
		map.put("ddSiNo", ddsino);
		
		return "plugin/recobroConfig/metasVolantes/recobroModificarMetas";
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String guardaMetasVolantes(RecobroDtoMetaVolante dto, ModelMap map) {
		
		proxyFactory.proxy(RecobroItinerarioApi.class).guardaMetasVolantes(dto);
		
		List listaMetas = proxyFactory.proxy(RecobroItinerarioApi.class).buscaMetasPorItinerario(dto.getIdItinerario());
		map.put("listaMetas", listaMetas);
		
		return "plugin/recobroConfig/metasVolantes/recobroListaMetasJSON" ;
	}


	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String eliminaItinerarioRecobro(RecobroDtoItinerario dto, ModelMap map) {
		
		if (!Checks.esNulo(dto.getId())){
			proxyFactory.proxy(RecobroItinerarioApi.class).eliminaItinerario(Long.valueOf(dto.getId()));
		}
		
		return "default";
	}
	
	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String descartaCambiosMetasVolantes(RecobroDtoItinerario dto, ModelMap map) {
		return "default";
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String copiarItinerarioMetasVolantes(Long id, ModelMap map) {
		
		proxyFactory.proxy(RecobroItinerarioApi.class).copiaItinerarioMetasVolantes(id);
		
		return "default";
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@RequestMapping
	@Secured("ROLE_VER_METAS")
	public String liberarItinerarioMetasVolantes(Long id, ModelMap map) {
		proxyFactory.proxy(RecobroItinerarioApi.class).cambiaEstadoItinerario(id, RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE);
		
		return "default";
	}

	
}
