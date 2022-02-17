package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;

@SuppressWarnings("rawtypes")
class ActivoControllerDispachableMethods {

	static abstract class DispachableMethod<T> {
		protected ActivoController controller;

		protected void setController(ActivoController c)  {
			this.controller = c;
		}

		public abstract Class<T> getArgumentType();
		public abstract void execute(Long id, T dto, HttpServletRequest request);
	}

	private static Map<String, DispachableMethod> dispachableMethods;

	static {
		dispachableMethods = new HashMap<String, DispachableMethod>();
		
		/*
		 * TAB DATOS BASICOS
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_DATOS_BASICOS, new DispachableMethod<DtoActivoFichaCabecera>() {

			@Override
			public Class<DtoActivoFichaCabecera> getArgumentType() {
				return DtoActivoFichaCabecera.class;
			}

			@Override
			public void execute(Long id, DtoActivoFichaCabecera dto, HttpServletRequest request) {
				if (dto != null ){
					ModelAndView mm = this.controller.saveDatosBasicos(dto, id, new ModelMap());

					if ("false".equals(mm.getModel().get("success").toString())
						&& !Checks.esNulo(mm.getModel().get("msgError"))) {

						throw new JsonViewerException(mm.getModel().get("msgError").toString());
					}
				}
			}
		});

		/*
		 * TAB SITUACION POSESORIA
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_SIT_POSESORIA, new DispachableMethod<DtoActivoSituacionPosesoria>() {

			@Override
			public Class<DtoActivoSituacionPosesoria> getArgumentType() {
				return DtoActivoSituacionPosesoria.class;
			}

			@Override
			public void execute(Long id, DtoActivoSituacionPosesoria dto, HttpServletRequest request) {
				if (dto != null ){
					ActivoApi activoApi=controller.getActivoApi();
					if(activoApi.compruebaParaEnviarEmailAvisoOcupacion(dto, id)) {
						this.controller.saveActivoSituacionPosesoria(dto, id, new ModelMap(), request);
					}else {
						throw new JsonViewerException("Informe okupación y/o desokupación no adjunto. Se necesita para poder guardar el activo como ocupado SI y con título NO");
					}

				}
				
			}
		});
		
		/*
		 * TAB INFORME COMERCIAL
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_INFORME_COMERCIAL, new DispachableMethod<DtoActivoInformeComercial>() {

			@Override
			public Class<DtoActivoInformeComercial> getArgumentType() {
				return DtoActivoInformeComercial.class;
			}

			@Override
			public void execute(Long id, DtoActivoInformeComercial dto, HttpServletRequest request) {
				if (dto != null ){
					this.controller.saveActivoInformeComercial(dto, id, new ModelMap(), request);
				}
				
			}
		});
		
		/*
		 * TAB DATOS REGISTRALES
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_DATOS_REGISTRALES, new DispachableMethod<DtoActivoDatosRegistrales>() {

			@Override
			public Class<DtoActivoDatosRegistrales> getArgumentType() {
				return DtoActivoDatosRegistrales.class;
			}

			@Override
			public void execute(Long id, DtoActivoDatosRegistrales dto, HttpServletRequest request) {
				if (dto != null ){
					this.controller.saveActivoDatosRegistrales(dto, id, new ModelMap());
				}
				
			}
		});
		
		/*
		 * TAB INFO ADMINISTRATIVA
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_INFO_ADMINISTRATIVA, new DispachableMethod<DtoActivoInformacionAdministrativa>() {

			@Override
			public Class<DtoActivoInformacionAdministrativa> getArgumentType() {
				return DtoActivoInformacionAdministrativa.class;
			}

			@Override
			public void execute(Long id, DtoActivoInformacionAdministrativa dto, HttpServletRequest request) {
				if (dto != null ){
					this.controller.saveActivoInformacionAdministrativa(dto, id, new ModelMap());
				}
				
			}
		});
		
		/*
		 * TAB CARGAS ACTIVO
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_CARGAS_ACTIVO, new DispachableMethod<DtoActivoCargasTab>() {

			@Override
			public Class<DtoActivoCargasTab> getArgumentType() {
				return DtoActivoCargasTab.class;
			}

			@Override
			public void execute(Long id, DtoActivoCargasTab dto, HttpServletRequest request) {
				if (dto != null ){
					dto.setIdActivo(id);
					this.controller.saveActivoCargaTab(dto, new ModelMap());
				}
			}
		});
		
		/*
		 * TAB_MEDIADOR_ACTIVO
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_MEDIADOR_ACTIVO, new DispachableMethod<DtoHistoricoMediador>() {

			@Override
			public Class<DtoHistoricoMediador> getArgumentType() {
				return DtoHistoricoMediador.class;
			}

			@Override
			public void execute(Long id, DtoHistoricoMediador dto, HttpServletRequest request) {
				if (dto != null ){
					List<DtoHistoricoMediador> list = controller.getHistoricoMediadorByActivo(id);
					dto.setCodigo(list.get(0).getCodigo());
					this.controller.createHistoricoMediador(dto, new ModelMap());
				}
			}
		});
		
		/*
		 * TAB_CALIFICACION_NEGATIVA
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_CALIFICACION_NEGATIVA, new DispachableMethod<DtoActivoDatosRegistrales>() {

			@Override
			public Class<DtoActivoDatosRegistrales> getArgumentType() {
				return DtoActivoDatosRegistrales.class;
			}

			@Override
			public void execute(Long id, DtoActivoDatosRegistrales dto, HttpServletRequest request) {
				if (dto != null ){
					
					List<DtoActivoDatosRegistrales> l_DatosRegistralesAux = this.controller.getCalificacionNegativabyId(id);
					List<DtoActivoDatosRegistrales> l_DatosRegistrales = new ArrayList<DtoActivoDatosRegistrales>();
					
					for (DtoActivoDatosRegistrales dtoADR : l_DatosRegistralesAux) {
						if (dto.getIdsMotivo().contains(dtoADR.getIdMotivo())) {
							l_DatosRegistrales.add(dtoADR);
						}
					}
					
					for (int i = 0; i < l_DatosRegistrales.size(); i++) {
						l_DatosRegistrales.get(i).setIdActivo(dto.getIdActivo());
						this.controller.createCalificacionNegativa(dto.getIdActivo(), l_DatosRegistrales.get(i), new ModelMap());
					}
					
				}
				
			}
		});

		/*
		 * TAB_CONDICIONES_ESPECIFICAS
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_CONDICIONES_ESPECIFICAS, new DispachableMethod<DtoCondicionEspecifica>() {

			@Override
			public Class<DtoCondicionEspecifica> getArgumentType() {
				return DtoCondicionEspecifica.class;
			}

			@Override
			public void execute(Long idActivo, DtoCondicionEspecifica dto, HttpServletRequest request) {
				if (dto != null){
					this.controller.createCondicionEspecifica(dto, new ModelMap());
				}
//				ModelAndView l_CondicionEspecificaAux = this.controller.getCondicionEspecificaByActivo(idActivo, new ModelMap());
//				List<DtoCondicionEspecifica> l_CondicionEspecifica = new ArrayList<DtoCondicionEspecifica>();
//				
//				for (DtoCondicionEspecifica dtoCE : l_CondicionEspecificaAux) {
//					if (dto.getTexto().contains(dtoCE.getTexto())) {
//						l_CondicionEspecifica.add(dtoCE);
//					}
//				}
//				
//				for (int i = 0; i < l_CondicionEspecifica.size(); i++) {
//					l_CondicionEspecifica.get(i).setIdActivo(dto.getIdActivo());
//					this.controller.createCondicionEspecifica((DtoCondicionEspecifica) l_CondicionEspecifica, new ModelMap());
//				}
				
			}
		});

		/*
		 * TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD, new DispachableMethod<DtoCondicionantesDisponibilidad>() {

			@Override
			public Class<DtoCondicionantesDisponibilidad> getArgumentType() {
				return DtoCondicionantesDisponibilidad.class;
			}

			@Override
			public void execute(Long id, DtoCondicionantesDisponibilidad dto, HttpServletRequest request) {
				if (dto != null ){
					this.controller.saveCondicionantesDisponibilidad(id,dto, new ModelMap(), request);
				}
			}
		});

		/*
		 * TAB_COMERCIAL
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_COMERCIAL, new DispachableMethod<DtoComercialActivo>() {

			@Override
			public Class<DtoComercialActivo> getArgumentType() {
				return DtoComercialActivo.class;
			}

			@Override
			public void execute(Long id, DtoComercialActivo dto, HttpServletRequest request) {
				if (dto != null ){
					dto.setId(id.toString());
					this.controller.saveComercialActivo(dto, new ModelMap(), request);

				}
			}
		});

		/*
		 * TAB_ADMINISTRACION
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_ADMINISTRACION, new DispachableMethod<DtoActivoAdministracion>() {

			@Override
			public Class<DtoActivoAdministracion> getArgumentType() {
				return DtoActivoAdministracion.class;
			}

			@Override
			public void execute(Long id, DtoActivoAdministracion dto, HttpServletRequest request) {
				if (dto != null ){
					this.controller.saveActivoAdministracion(dto, id, new ModelMap(), request);

				}
			}
		});

		/*
		 * TAB_DATOS_PUBLICACION
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_DATOS_PUBLICACION, new DispachableMethod<DtoDatosPublicacionActivo>() {

			@Override
			public Class<DtoDatosPublicacionActivo> getArgumentType() {
				return DtoDatosPublicacionActivo.class;
			}

			@Override
			public void execute(Long id, DtoDatosPublicacionActivo dto, HttpServletRequest request) {
				if (dto != null ){
					dto.setIdActivo(id);
					this.controller.setDatosPublicacionActivo(dto, new ModelMap());
				}
			}
		});

		/*
		 * TAB_TASACIONES
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_TASACION, new DispachableMethod<DtoTasacion>() {

			@Override
			public Class<DtoTasacion> getArgumentType() {
				return DtoTasacion.class;
			}

			@Override
			public void execute(Long id, DtoTasacion dto, HttpServletRequest request) {
				if (dto != null ){
					this.controller.saveTasacionActivo(dto, new ModelMap(), request);
				}
			}
		});

		/*
		 * TAB_PATRIMONIO
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_PATRIMONIO, new DispachableMethod<DtoActivoPatrimonio>() {

			@Override
			public Class<DtoActivoPatrimonio> getArgumentType() {
				return DtoActivoPatrimonio.class;
			}

			@Override
			public void execute(Long id, DtoActivoPatrimonio dto, HttpServletRequest request) {
				if (dto != null ){
					this.controller.saveDatosPatrimonio(dto, id, new ModelMap(), request);
				}
			}
		});
		
		/*
		 * TAB_PLUSVALIA
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_PLUSVALIA, new DispachableMethod<DtoActivoPlusvalia>() {

			@Override
			public Class<DtoActivoPlusvalia> getArgumentType() {
				return DtoActivoPlusvalia.class;
			}

			@Override
			public void execute(Long id, DtoActivoPlusvalia dto, HttpServletRequest request) {
				if (dto != null ){
					this.controller.saveDatosPlusvalia(dto, id, new ModelMap(), request);
				}
			}
		});

		/*
		 * TAB_COMUNIDAD-ENTIDADES
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_COMUNIDAD_PROPIETARIOS, new DispachableMethod<DtoComunidadpropietariosActivo>() {

			@Override
			public Class<DtoComunidadpropietariosActivo> getArgumentType() {
				return DtoComunidadpropietariosActivo.class;
			}

			@Override
			public void execute(Long id, DtoComunidadpropietariosActivo dto, HttpServletRequest request) {
				if (dto != null ){
					this.controller.saveActivoComunidadPropietarios(dto, id, new ModelMap(), request);

				}
			}
		});
		
		/*
		 * TAB_FASE_PUBLICACION
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_FASE_PUBLICACION, new DispachableMethod<DtoFasePublicacionActivo>() {
			@Override
			public Class<DtoFasePublicacionActivo> getArgumentType() {
				return DtoFasePublicacionActivo.class;
			}
			
			@Override
			public void execute(Long id, DtoFasePublicacionActivo dto, HttpServletRequest request) {
				if (dto != null) {					
					this.controller.saveFasePublicacionActivo(dto, id, new ModelMap());
				}
			}
		});
		
		/*
		 * TAB_SANEAMIENTO
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_SANEAMIENTO, new DispachableMethod<DtoActivoSaneamiento>() {
			@Override
			public Class<DtoActivoSaneamiento> getArgumentType() {
				return DtoActivoSaneamiento.class;
			}
			
			@Override
			public void execute(Long id, DtoActivoSaneamiento dto, HttpServletRequest request) {
				if (dto != null) {
					ModelAndView mm = this.controller.saveActivoSaneamiento(dto, id, new ModelMap());
					if ("false".equals(mm.getModel().get("success").toString())
							&& !Checks.esNulo(mm.getModel().get("msgError"))) {
							throw new JsonViewerException(mm.getModel().get("msgError").toString());
					}
				}
			}
		});
		
		/*
		 * TAB_BBVA_UIC
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_BBVA_UIC_ACTIVO, new DispachableMethod<DtoActivoBbvaUic>() {

			@Override
			public Class<DtoActivoBbvaUic> getArgumentType() {
				return DtoActivoBbvaUic.class;
			}

			@Override
			public void execute(Long id, DtoActivoBbvaUic dto, HttpServletRequest request) {
				if (dto != null ){
					boolean existe = false;
					List<DtoActivoBbvaUic> listBbvaActivoProp = controller.getActivoBbvaUic(dto.getIdActivo());
					
					for (DtoActivoBbvaUic dtoActivoBbvaUic : listBbvaActivoProp) {
						if (dtoActivoBbvaUic.getUicBbva().equals(dto.getUicBbva())) {
							existe = true;
						}
					}
					
					if (!existe) {
						this.controller.createActivoBbvaUic(dto, new ModelMap());
					}
				}
			}
		});
	}

	private ActivoController controller;

	ActivoControllerDispachableMethods(ActivoController c) {
		this.controller = c;	
	}

	DispachableMethod findDispachableMethod(String modelName) {
		return configure(dispachableMethods.get(modelName));
	}

	private DispachableMethod configure(DispachableMethod m) {
		if (m != null) {
			m.setController(this.controller);
		}
		return m;
	}

}
