package es.pfsgroup.plugin.rem.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.ModelMap;

import es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap;
import es.pfsgroup.plugin.rem.model.DtoActivoAdministracion;
import es.pfsgroup.plugin.rem.model.DtoActivoCargasTab;
import es.pfsgroup.plugin.rem.model.DtoActivoDatosRegistrales;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoActivoInformacionAdministrativa;
import es.pfsgroup.plugin.rem.model.DtoActivoInformeComercial;
import es.pfsgroup.plugin.rem.model.DtoActivoSituacionPosesoria;

import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoCondicionantesDisponibilidad;

import es.pfsgroup.plugin.rem.model.DtoComercialActivo;
import es.pfsgroup.plugin.rem.model.DtoComunidadpropietariosActivo;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;

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
					this.controller.saveDatosBasicos(dto, id, new ModelMap());
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
					this.controller.saveActivoSituacionPosesoria(dto, id, new ModelMap(), request);
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
			}
		});

		/*
		 * TAB_ACTIVO_HISTORICO_ESTADO_PUBLICACION
		 */
		dispachableMethods.put(ActivoPropagacionFieldTabMap.TAB_ACTIVO_HISTORICO_ESTADO_PUBLICACION, new DispachableMethod<DtoCambioEstadoPublicacion>() {

			@Override
			public Class<DtoCambioEstadoPublicacion> getArgumentType() {
				return DtoCambioEstadoPublicacion.class;
			}

			@Override
			public void execute(Long id, DtoCambioEstadoPublicacion dto, HttpServletRequest request) {
				if (dto != null ){
					dto.setIdActivo(id);
					this.controller.setHistoricoEstadoPublicacion(dto, new ModelMap());
				}
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
	}
	
	
	private ActivoController controller;
	
	public ActivoControllerDispachableMethods(ActivoController c) {
		this.controller = c;
	}
	
	public DispachableMethod findDispachableMethod(String modelName) {
		return configure(dispachableMethods.get(modelName));
	}

	private DispachableMethod configure(DispachableMethod m) {
		if (m != null) {
			m.setController(this.controller);
		}
		return m;
	}

}
