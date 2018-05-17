package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoComunidadPropietarios;
import es.pfsgroup.plugin.rem.model.DtoComunidadpropietariosActivo;

@Component
public class TabActivoDatosComunidad implements TabActivoService {

	protected static final Log logger = LogFactory.getLog(ActivoManager.class);

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private TabActivoFactoryApi tabActivoFactory;
	
	@Autowired
	private ActivoApi activoApi;

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[] { TabActivoService.TAB_COMUNIDAD_PROPIETARIOS };
	}

	/**
	 * Método que devuelve un DTO para la carga del modelo de Informe Comercial del Activo
	 * 
	 * @param Activo
	 * @return DtoActivoInformeComercial
	 */
	public DtoComunidadpropietariosActivo getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoComunidadpropietariosActivo datosComunidad = new DtoComunidadpropietariosActivo();

		try {

			if (!Checks.esNulo(activo.getComunidadPropietarios())) {
				// Copia al "informe comercial" todos los atributos de "informacion comercial".
				beanUtilNotNull.copyProperties(datosComunidad, activo.getComunidadPropietarios());

				if (!Checks.esNulo(activo.getComunidadPropietarios().getFechaComunicacionComunidad())) {
					beanUtilNotNull.copyProperty(datosComunidad, "fechaComunicacionComunidad", activo.getComunidadPropietarios().getFechaComunicacionComunidad());
				}

				if (!Checks.esNulo(activo.getComunidadPropietarios().getEnvioCartas())) {
					beanUtilNotNull.copyProperty(datosComunidad, "envioCartas", activo.getComunidadPropietarios().getEnvioCartas());
				}

				if (!Checks.esNulo(activo.getComunidadPropietarios().getNumCartas())) {
					beanUtilNotNull.copyProperty(datosComunidad, "numCartas", activo.getComunidadPropietarios().getNumCartas());
				}

				if (!Checks.esNulo(activo.getComunidadPropietarios().getContactoTel())) {
					beanUtilNotNull.copyProperty(datosComunidad, "contactoTel", activo.getComunidadPropietarios().getContactoTel());
				}

				if (!Checks.esNulo(activo.getComunidadPropietarios().getVisita())) {
					beanUtilNotNull.copyProperty(datosComunidad, "visita", activo.getComunidadPropietarios().getVisita());
				}

				if (!Checks.esNulo(activo.getComunidadPropietarios().getBurofax())) {
					beanUtilNotNull.copyProperty(datosComunidad, "burofax", activo.getComunidadPropietarios().getBurofax());
				}
			}
			datosComunidad.setCamposPropagables(TabActivoService.TAB_COMUNIDAD_PROPIETARIOS);

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		

		return datosComunidad;
	}

	/**
	 * Método que guarda los valores del modelo de Informe Comercial del Activo. Devuelve un Activo
	 * con los valores que se han modificado en este, para su posterior guardado en el servicio
	 * principal de esta factoría.
	 * 
	 * @param Activo
	 * @param WebDto para parsear en DtoActivoInformeComercial
	 * @return Activo
	 */
	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
		DtoComunidadpropietariosActivo activoComunidadPropietariosDto = (DtoComunidadpropietariosActivo) webDto;

		try {

			
			if (Checks.esNulo(activo.getComunidadPropietarios())){
				ActivoComunidadPropietarios actComPropietarios = new ActivoComunidadPropietarios();
				activo.setComunidadPropietarios(actComPropietarios);
				genericDao.save(ActivoComunidadPropietarios.class, actComPropietarios);
			}
			
			if (!Checks.esNulo(activo.getComunidadPropietarios())) {
				beanUtilNotNull.copyProperties(activo.getComunidadPropietarios(), activoComunidadPropietariosDto);

				if (!Checks.esNulo(activoComunidadPropietariosDto.getFechaComunicacionComunidad())) {
					beanUtilNotNull.copyProperty(activo.getComunidadPropietarios(), "fechaComunicacionComunidad", activoComunidadPropietariosDto.getFechaComunicacionComunidad());
				}

				if (!Checks.esNulo(activoComunidadPropietariosDto.getEnvioCartas())) {
					beanUtilNotNull.copyProperty(activo.getComunidadPropietarios(), "envioCartas", activoComunidadPropietariosDto.getEnvioCartas());
				}

				if (!Checks.esNulo(activoComunidadPropietariosDto.getNumCartas())) {
					beanUtilNotNull.copyProperty(activo.getComunidadPropietarios(), "numCartas", activoComunidadPropietariosDto.getNumCartas());
				}

				if (!Checks.esNulo(activoComunidadPropietariosDto.getContactoTel())) {
					beanUtilNotNull.copyProperty(activo.getComunidadPropietarios(), "contactoTel", activoComunidadPropietariosDto.getContactoTel());
				}

				if (!Checks.esNulo(activoComunidadPropietariosDto.getVisita())) {
					beanUtilNotNull.copyProperty(activo.getComunidadPropietarios(), "visita", activoComunidadPropietariosDto.getVisita());
				}

				if (!Checks.esNulo(activoComunidadPropietariosDto.getBurofax())) {
					beanUtilNotNull.copyProperty(activo.getComunidadPropietarios(), "burofax", activoComunidadPropietariosDto.getBurofax());
				}
				
				activo.setComunidadPropietarios(genericDao.save(ActivoComunidadPropietarios.class, activo.getComunidadPropietarios()));
				activoApi.saveOrUpdate(activo);				
			}
			

			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return activo;
	}

}