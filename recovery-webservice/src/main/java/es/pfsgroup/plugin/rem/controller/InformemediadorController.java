package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.plugin.rem.api.InformeMediadorApi;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoLocalComercial;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.rest.dto.InformemediadorRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.PlantaDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class InformemediadorController {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RestApi restApi;

	@Autowired
	private InformeMediadorApi informeMediadorApi;

	@SuppressWarnings({ "unchecked"})
	@RequestMapping(method = RequestMethod.POST, value = "/informemediador")
	public ModelAndView saveInformeMediador(ModelMap model, RestRequestWrapper request) {
		Map<String, Object> map = null;
		InformemediadorRequestDto jsonData = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();

		try {
			jsonData = (InformemediadorRequestDto) request.getRequestData(InformemediadorRequestDto.class);
			List<InformeMediadorDto> informes = jsonData.getData();

			for (InformeMediadorDto informe : informes) {
				map = new HashMap<String, Object>();
				List<String> errorsList = null;
				if (informeMediadorApi.existeInformemediadorActivo(informe.getIdActivoHaya())) {
					errorsList = restApi.validateRequestObject(informe, TIPO_VALIDACION.INSERT);
					informeMediadorApi.validateInformeMediadorDto(informe, informe.getCodTipoActivo(), errorsList);
				} else {
					errorsList = restApi.validateRequestObject(informe, TIPO_VALIDACION.UPDATE);
				}
				if (informe.getPlantas() != null) {
					for (PlantaDto planta : informe.getPlantas()) {
						List<String> errorsListPlanta = null;
						if (informeMediadorApi.existeInformemediadorActivo(informe.getIdActivoHaya())) {
							errorsListPlanta = restApi.validateRequestObject(planta, TIPO_VALIDACION.INSERT);
						} else {
							errorsListPlanta = restApi.validateRequestObject(planta, TIPO_VALIDACION.UPDATE);
						}
						errorsList.addAll(errorsListPlanta);
					}
				}

				if (errorsList.size() == 0) {

					ActivoInfoComercial informeEntity = null;

					if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_COMERCIAL)) {
						informeEntity = (ActivoLocalComercial) restApi.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoLocalComercial.class,"activo");
						informeEntity = (ActivoInfoComercial) restApi.saveDtoToBbdd(informe, informeEntity);
					} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_EDIFICIO_COMPLETO)) {
						ActivoEdificio edificioEntity = (ActivoEdificio) restApi
								.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoEdificio.class,"infoComercial.activo");
						informeEntity = (ActivoInfoComercial) restApi.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoInfoComercial.class,"activo");
						edificioEntity.setInfoComercial(informeEntity);
						informeEntity = (ActivoInfoComercial) restApi.saveDtoToBbdd(informe, informeEntity,edificioEntity);
					} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_EN_COSTRUCCION)) {
						informeEntity = (ActivoInfoComercial) restApi.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoInfoComercial.class,"activo");
						informeEntity = (ActivoInfoComercial) restApi.saveDtoToBbdd(informe, informeEntity);
					} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_INDUSTRIAL)) {
						informeEntity = (ActivoInfoComercial) restApi.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoInfoComercial.class,"activo");
						informeEntity = (ActivoInfoComercial) restApi.saveDtoToBbdd(informe, informeEntity);
					} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_OTROS)) {
						informeEntity = (ActivoInfoComercial) restApi.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoInfoComercial.class,"activo");
						informeEntity = (ActivoInfoComercial) restApi.saveDtoToBbdd(informe, informeEntity);
					} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_SUELO)) {
						informeEntity = (ActivoInfoComercial) restApi.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoInfoComercial.class,"activo");
						informeEntity = (ActivoInfoComercial) restApi.saveDtoToBbdd(informe, informeEntity);
					} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_VIVIENDA)) {
						informeEntity = (ActivoVivienda) restApi.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoVivienda.class,"activo");
						informeEntity = (ActivoInfoComercial) restApi.saveDtoToBbdd(informe, informeEntity);
					}

					
					if(informeEntity.getId()==null){
						informeEntity = (ActivoInfoComercial) restApi.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoVivienda.class,"activo");
					}
					map.put("idinformeMediadorWebcom", informe.getIdInformeMediadorWebcom());
					map.put("idinformeMediadorRem", informeEntity.getId());
					map.put("success", true);
				} else {
					map.put("idinformeMediadorWebcom", informe.getIdInformeMediadorWebcom());
					map.put("success", false);
					map.put("errorMessages", errorsList);
				}

				listaRespuesta.add(map);
			}
			model.put("id", jsonData.getId());
			model.put("data", listaRespuesta);
			model.put("error", "");
		} catch (Exception e) {
			logger.error(e);
			if (jsonData != null) {
				model.put("id", jsonData.getId());
			}
			model.put("data", listaRespuesta);
			model.put("error", e.getMessage().toUpperCase());
		}

		return new ModelAndView("jsonView", model);

	}
}
