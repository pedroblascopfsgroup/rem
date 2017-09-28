package es.pfsgroup.plugin.rem.controller;

import static es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap.TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD;
import static es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap.TAB_ACTIVO_HISTORICO_ESTADO_PUBLICACION;
import static es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap.TAB_CARGAS_ACTIVO;
import static es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap.TAB_DATOS_BASICOS;
import static es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap.TAB_DATOS_PUBLICACION;
import static es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap.TAB_DATOS_REGISTRALES;
import static es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap.TAB_INFORME_COMERCIAL;
import static es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap.TAB_INFO_ADMINISTRATIVA;
import static es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap.TAB_MEDIADOR_ACTIVO;
import static es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap.TAB_SIT_POSESORIA;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.ui.ModelMap;

import es.pfsgroup.plugin.rem.model.DtoActivoCargasTab;
import es.pfsgroup.plugin.rem.model.DtoActivoDatosRegistrales;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoActivoInformacionAdministrativa;
import es.pfsgroup.plugin.rem.model.DtoActivoInformeComercial;
import es.pfsgroup.plugin.rem.model.DtoActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;

class ActivoControllerDispachableMethods {
	
	static abstract class DispachableMethod<T> {
		protected ActivoController controller;
		
		protected void setController(ActivoController c)  {
			this.controller = c;
		}
		
		public abstract Class<T> getArgumentType();
		public abstract void execute(Long id, T dto);
	}
	
	
	private static Map<String, DispachableMethod> dispachableMethods;
	
	static {
		dispachableMethods = new HashMap<String, DispachableMethod>();
		
		/*
		 * TAB DATOS BASICOS
		 */
		dispachableMethods.put(TAB_DATOS_BASICOS, new DispachableMethod<DtoActivoFichaCabecera>() {

			@Override
			public Class<DtoActivoFichaCabecera> getArgumentType() {
				return DtoActivoFichaCabecera.class;
			}

			@Override
			public void execute(Long id, DtoActivoFichaCabecera dto) {
				if (dto != null ){
					this.controller.saveDatosBasicos(dto, id, new ModelMap());
				}
				
			}
		});
		
		/*
		 * TAB SITUACION POSESORIA
		 */
		dispachableMethods.put(TAB_SIT_POSESORIA, new DispachableMethod<DtoActivoSituacionPosesoria>() {

			@Override
			public Class<DtoActivoSituacionPosesoria> getArgumentType() {
				return DtoActivoSituacionPosesoria.class;
			}

			@Override
			public void execute(Long id, DtoActivoSituacionPosesoria dto) {
				if (dto != null ){
					this.controller.saveActivoSituacionPosesoria(dto, id, new ModelMap());
				}
				
			}
		});
		
		/*
		 * TAB INFORME COMERCIAL
		 */
		dispachableMethods.put(TAB_INFORME_COMERCIAL, new DispachableMethod<DtoActivoInformeComercial>() {

			@Override
			public Class<DtoActivoInformeComercial> getArgumentType() {
				return DtoActivoInformeComercial.class;
			}

			@Override
			public void execute(Long id, DtoActivoInformeComercial dto) {
				if (dto != null ){
					this.controller.saveActivoInformeComercial(dto, id, new ModelMap());
				}
				
			}
		});
		
		/*
		 * TAB DATOS REGISTRALES
		 */
		dispachableMethods.put(TAB_DATOS_REGISTRALES, new DispachableMethod<DtoActivoDatosRegistrales>() {

			@Override
			public Class<DtoActivoDatosRegistrales> getArgumentType() {
				return DtoActivoDatosRegistrales.class;
			}

			@Override
			public void execute(Long id, DtoActivoDatosRegistrales dto) {
				if (dto != null ){
					this.controller.saveActivoDatosRegistrales(dto, id, new ModelMap());
				}
				
			}
		});
		
		/*
		 * TAB INFO ADMINISTRATIVA
		 */
		dispachableMethods.put(TAB_INFO_ADMINISTRATIVA, new DispachableMethod<DtoActivoInformacionAdministrativa>() {

			@Override
			public Class<DtoActivoInformacionAdministrativa> getArgumentType() {
				return DtoActivoInformacionAdministrativa.class;
			}

			@Override
			public void execute(Long id, DtoActivoInformacionAdministrativa dto) {
				if (dto != null ){
					this.controller.saveActivoInformacionAdministrativa(dto, id, new ModelMap());
				}
				
			}
		});
		
		/*
		 * TAB CARGAS ACTIVO
		 */
		dispachableMethods.put(TAB_CARGAS_ACTIVO, new DispachableMethod<DtoActivoCargasTab>() {

			@Override
			public Class<DtoActivoCargasTab> getArgumentType() {
				return DtoActivoCargasTab.class;
			}

			@Override
			public void execute(Long id, DtoActivoCargasTab dto) {
				if (dto != null ){
					dto.setIdActivo(id);
					this.controller.saveActivoCargaTab(dto, new ModelMap());
				}
			}
		});
		
		/*
		 * TAB_MEDIADOR_ACTIVO
		 */
		dispachableMethods.put(TAB_MEDIADOR_ACTIVO, new DispachableMethod<DtoHistoricoMediador>() {

			@Override
			public Class<DtoHistoricoMediador> getArgumentType() {
				return DtoHistoricoMediador.class;
			}

			@Override
			public void execute(Long id, DtoHistoricoMediador dto) {
				if (dto != null ){
					List<DtoHistoricoMediador> list = controller.getHistoricoMediadorByActivo(id);
					dto.setCodigo(list.get(0).getCodigo());
					this.controller.createHistoricoMediador(dto, new ModelMap());
				}
			}
		});
		
		/*
		 * TAB_ACTIVO_HISTORICO_ESTADO_PUBLICACION
		 */
		dispachableMethods.put(TAB_ACTIVO_HISTORICO_ESTADO_PUBLICACION, new DispachableMethod<DtoCambioEstadoPublicacion>() {

			@Override
			public Class<DtoCambioEstadoPublicacion> getArgumentType() {
				return DtoCambioEstadoPublicacion.class;
			}

			@Override
			public void execute(Long id, DtoCambioEstadoPublicacion dto) {
				if (dto != null ){
					dto.setIdActivo(id);
					this.controller.setHistoricoEstadoPublicacion(dto, new ModelMap());
				}
			}
		});
		
		/*
		 * TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD
		 */
		dispachableMethods.put(TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD, new DispachableMethod<DtoCondicionantesDisponibilidad>() {

			@Override
			public Class<DtoCondicionantesDisponibilidad> getArgumentType() {
				return DtoCondicionantesDisponibilidad.class;
			}

			@Override
			public void execute(Long id, DtoCondicionantesDisponibilidad dto) {
				if (dto != null ){
					this.controller.saveCondicionantesDisponibilidad(id,dto, new ModelMap());
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
