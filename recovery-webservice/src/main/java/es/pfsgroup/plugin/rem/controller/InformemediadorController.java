package es.pfsgroup.plugin.rem.controller;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.InformeMediadorApi;
import es.pfsgroup.plugin.rem.model.ActivoBanyo;
import es.pfsgroup.plugin.rem.model.ActivoCarpinteriaExterior;
import es.pfsgroup.plugin.rem.model.ActivoCarpinteriaInterior;
import es.pfsgroup.plugin.rem.model.ActivoCocina;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoInfraestructura;
import es.pfsgroup.plugin.rem.model.ActivoInstalacion;
import es.pfsgroup.plugin.rem.model.ActivoLocalComercial;
import es.pfsgroup.plugin.rem.model.ActivoParamentoVertical;
import es.pfsgroup.plugin.rem.model.ActivoPlazaAparcamiento;
import es.pfsgroup.plugin.rem.model.ActivoSolado;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.ActivoZonaComun;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.rest.api.DtoToEntityApi;
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
	
	@Autowired
	private DtoToEntityApi dtoToEntity;

	@Autowired
	private ActivoApi activoApi;

	@SuppressWarnings({ "unchecked" })
	@RequestMapping(method = RequestMethod.POST, value = "/informemediador")
	public void saveInformeMediador(ModelMap model, RestRequestWrapper request,HttpServletResponse response) {
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

					ArrayList<Serializable> entitys = new ArrayList<Serializable>();
					if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_COMERCIAL)) {
						informeEntity = (ActivoLocalComercial) dtoToEntity.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoLocalComercial.class, "activo.numActivo");
						entitys.add(informeEntity);
					} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_EDIFICIO_COMPLETO)) {
						ActivoEdificio edificioEntity = (ActivoEdificio) dtoToEntity.obtenerObjetoEntity(
								informe.getIdActivoHaya(), ActivoEdificio.class, "infoComercial.activo");
						informeEntity = (ActivoInfoComercial) dtoToEntity.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoInfoComercial.class, "activo.numActivo");
						edificioEntity.setInfoComercial(informeEntity);
						entitys.add(informeEntity);
						entitys.add(edificioEntity);

					} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_EN_COSTRUCCION)) {
						informeEntity = (ActivoInfoComercial) dtoToEntity.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoInfoComercial.class, "activo.numActivo");
						entitys.add(informeEntity);
					} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_INDUSTRIAL)) {
						informeEntity = (ActivoInfoComercial) dtoToEntity.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoInfoComercial.class, "activo.numActivo");
						entitys.add(informeEntity);
					} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_OTROS)) {
						informeEntity = (ActivoPlazaAparcamiento) dtoToEntity.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoPlazaAparcamiento.class, "activo.numActivo");
						entitys.add(informeEntity);
					} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_SUELO)) {
						informeEntity = (ActivoInfoComercial) dtoToEntity.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoInfoComercial.class, "activo.numActivo");
						entitys.add(informeEntity);
					} else if (informe.getCodTipoActivo().equals(DDTipoActivo.COD_VIVIENDA)) {
						informeEntity = (ActivoVivienda) dtoToEntity.obtenerObjetoEntity(informe.getIdActivoHaya(),
								ActivoVivienda.class, "activo.numActivo");
						ActivoInfraestructura activoInfraestructura = (ActivoInfraestructura) dtoToEntity
								.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoInfraestructura.class,
										"infoComercial.activo.numActivo");
						ActivoCarpinteriaInterior activoCarpinteriaInt = (ActivoCarpinteriaInterior) dtoToEntity
								.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoCarpinteriaInterior.class,
										"infoComercial.activo.numActivo");
						
						ActivoCarpinteriaExterior activoCarpinteriaExterior = (ActivoCarpinteriaExterior) dtoToEntity
						.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoCarpinteriaExterior.class,
								"infoComercial.activo.numActivo");
						
						ActivoParamentoVertical paramientoVertical = (ActivoParamentoVertical) dtoToEntity
								.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoParamentoVertical.class,
										"infoComercial.activo.numActivo");
						
						ActivoSolado solado = (ActivoSolado) dtoToEntity
								.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoSolado.class,
										"infoComercial.activo.numActivo");
						
						ActivoCocina cocina = (ActivoCocina) dtoToEntity
								.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoCocina.class,
										"infoComercial.activo.numActivo");
						
						ActivoBanyo banyo = (ActivoBanyo) dtoToEntity
								.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoBanyo.class,
										"infoComercial.activo.numActivo");
						
						ActivoInstalacion instalacion = (ActivoInstalacion) dtoToEntity
						.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoInstalacion.class,
								"infoComercial.activo.numActivo");
						
						ActivoZonaComun zonaComun =(ActivoZonaComun) dtoToEntity
								.obtenerObjetoEntity(informe.getIdActivoHaya(), ActivoZonaComun.class,
										"infoComercial.activo.numActivo");
						
						entitys.add(informeEntity);
						entitys.add(activoInfraestructura);
						entitys.add(activoCarpinteriaInt);
						entitys.add(activoCarpinteriaExterior);
						entitys.add(paramientoVertical);
						entitys.add(solado);
						entitys.add(cocina);
						entitys.add(banyo);
						entitys.add(instalacion);
						entitys.add(zonaComun);
					}
					if (informeEntity.getActivo() == null) {
						informeEntity.setActivo(activoApi.getByNumActivo(informe.getIdActivoHaya()));
					}
					informeEntity = (ActivoInfoComercial) dtoToEntity.saveDtoToBbdd(informe, entitys);

					map.put("idinformeMediadorWebcom", informe.getIdInformeMediadorWebcom());
					map.put("idinformeMediadorRem", informeEntity.getId());
					map.put("success", new Boolean(true));
				} else {
					map.put("idinformeMediadorWebcom", informe.getIdInformeMediadorWebcom());
					map.put("success", new Boolean(false));
					map.put("errorMessages", errorsList);
				}

				listaRespuesta.add(map);
			}
			model.put("id", jsonData.getId());
			model.put("data", listaRespuesta);
			model.put("error", "");
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e);
			if (jsonData != null) {
				model.put("id", jsonData.getId());
			}
			model.put("data", listaRespuesta);
			model.put("error", e.getMessage().toUpperCase());
		}
		
		restApi.sendResponse(response,model);
		//return new ModelAndView("jsonView", model);

	}
}
