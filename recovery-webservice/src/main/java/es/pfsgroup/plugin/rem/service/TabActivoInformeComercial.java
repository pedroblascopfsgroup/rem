package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoComunidadPropietarios;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoLocalComercial;
import es.pfsgroup.plugin.rem.model.ActivoPlazaAparcamiento;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.DtoActivoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConstruccion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;

@Component
public class TabActivoInformeComercial implements TabActivoService {

	protected static final Log logger = LogFactory.getLog(ActivoManager.class);

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private TabActivoFactoryApi tabActivoFactory;

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[] { TabActivoService.TAB_INFORME_COMERCIAL };
	}

	/**
	 * Método que devuelve un DTO para la carga del modelo de Informe Comercial del Activo
	 * 
	 * @param Activo
	 * @return DtoActivoInformeComercial
	 */
	public DtoActivoInformeComercial getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoInformeComercial informeComercial = new DtoActivoInformeComercial();

		try {
			// Rellenamos los datos desde el tab de InformacionComercial, que comparten datos. Luego
			// seteamos a null los que podrían sobreescribirse.
			TabActivoInformacionComercial tabActivoInformacionComerial = (TabActivoInformacionComercial) tabActivoFactory.getService(TAB_INFORMACION_COMERCIAL);
			beanUtilNotNull.copyProperties(informeComercial, tabActivoInformacionComerial.getTabData(activo));
			informeComercial.setTipoActivoCodigo(null);
			informeComercial.setSubtipoActivoCodigo(null);

			if (!Checks.esNulo(activo.getInfoComercial())) {
				// Copia al "informe comercial" todos los atributos de "informacion comercial".
				beanUtilNotNull.copyProperties(informeComercial, activo.getInfoComercial());

				if (!Checks.esNulo(activo.getInfoComercial().getProvincia())) {
					beanUtilNotNull.copyProperty(informeComercial, "provinciaCodigo", activo.getInfoComercial().getProvincia().getCodigo());
				}

				if (!Checks.esNulo(activo.getInfoComercial().getLocalidad())) {
					beanUtilNotNull.copyProperty(informeComercial, "municipioCodigo", activo.getInfoComercial().getLocalidad().getCodigo());
				}

				if (!Checks.esNulo(activo.getInfoComercial().getTipoActivo())) {
					beanUtilNotNull.copyProperty(informeComercial, "tipoActivoCodigo", activo.getInfoComercial().getTipoActivo().getCodigo());

					// Segun el tipo de activo, recuperaremos unos u otros datos
					this.getDatosByTipoActivo(activo, informeComercial);
				}

				if (!Checks.esNulo(activo.getInfoComercial().getSubtipoActivo())) {
					beanUtilNotNull.copyProperty(informeComercial, "subtipoActivoCodigo", activo.getInfoComercial().getSubtipoActivo().getCodigo());
				}

				if (!Checks.esNulo(activo.getInfoComercial().getTipoVia())) {
					beanUtilNotNull.copyProperty(informeComercial, "tipoViaCodigo", activo.getInfoComercial().getTipoVia().getCodigo());
				}

				beanUtilNotNull.copyProperty(informeComercial, "numeroVia", activo.getInfoComercial().getNumeroVia());
				beanUtilNotNull.copyProperty(informeComercial, "planta", activo.getInfoComercial().getPlanta());

				if (!Checks.esNulo(activo.getInfoComercial().getUnidadPoblacional())) {
					beanUtilNotNull.copyProperty(informeComercial, "inferiorMunicipioCodigo", activo.getInfoComercial().getUnidadPoblacional().getCodigo());
				}

				if (!Checks.esNulo(activo.getInfoComercial().getUbicacionActivo())) {
					beanUtilNotNull.copyProperty(informeComercial, "ubicacionActivoCodigo", activo.getInfoComercial().getUbicacionActivo().getCodigo());
				}

				// Datos del mediador (proveedor).
				if (!Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
					beanUtilNotNull.copyProperty(informeComercial, "codigoMediador", activo.getInfoComercial().getMediadorInforme().getCodigoProveedorRem());
					beanUtilNotNull.copyProperty(informeComercial, "nombreMediador", activo.getInfoComercial().getMediadorInforme().getNombre());
					beanUtilNotNull.copyProperty(informeComercial, "telefonoMediador", activo.getInfoComercial().getMediadorInforme().getTelefono1());
					beanUtilNotNull.copyProperty(informeComercial, "emailMediador", activo.getInfoComercial().getMediadorInforme().getEmail());
				}
				
				// Datos de la Comunidad de vecinos al Dto.
				// Comunidad inscrita = constituida.
				beanUtilNotNull.copyProperty(informeComercial, "inscritaComunidad",
						activo.getInfoComercial().getExisteComunidadEdificio());
				// Derrama de la comunidad.
				beanUtilNotNull.copyProperty(informeComercial, "derramaOrientativaComunidad",
						activo.getInfoComercial().getDerramaOrientativaComunidad());
				// Cuota de la comunidad, tomada del importe medio.
				beanUtilNotNull.copyProperty(informeComercial, "cuotaOrientativaComunidad",
						activo.getInfoComercial().getCuotaOrientativaComunidad());
				// Nombre y telefono Presidente.
				beanUtilNotNull.copyProperty(informeComercial, "nomPresidenteComunidad",
						activo.getInfoComercial().getNombrePresidenteComunidadEdificio());
				beanUtilNotNull.copyProperty(informeComercial, "telPresidenteComunidad",
						activo.getInfoComercial().getTelefonoPresidenteComunidadEdificio());
				// Nombre y telefono Administrador.
				beanUtilNotNull.copyProperty(informeComercial, "nomAdministradorComunidad",
						activo.getInfoComercial().getNombreAdministradorComunidadEdificio());
				beanUtilNotNull.copyProperty(informeComercial, "telAdministradorComunidad",
						activo.getInfoComercial().getTelefonoAdministradorComunidadEdificio());
			}

			// Datos de la Comunidad de vecinos al Dto.
			if (!Checks.esNulo(activo.getComunidadPropietarios())) {
				ActivoComunidadPropietarios comunidadPropietarios = new ActivoComunidadPropietarios();
				comunidadPropietarios = activo.getComunidadPropietarios();

				// Comunidad inscrita = constituida.
				beanUtilNotNull.copyProperty(informeComercial, "inscritaComunidad", comunidadPropietarios.getConstituida());
				// Derrama de la comunidad.
				beanUtilNotNull.copyProperty(informeComercial, "derramaOrientativaComunidad", activo.getInfoComercial().getDerramaOrientativaComunidad());
				// Cuota de la comunidad, tomada del importe medio.
				beanUtilNotNull.copyProperty(informeComercial, "cuotaOrientativaComunidad", activo.getInfoComercial().getCuotaOrientativaComunidad());
				// Nombre y telefono Presidente.
				beanUtilNotNull.copyProperty(informeComercial, "nomPresidenteComunidad", comunidadPropietarios.getNomPresidente());
				beanUtilNotNull.copyProperty(informeComercial, "telPresidenteComunidad", comunidadPropietarios.getTelfPresidente());
				// Nombre y telefono Administrador.
				beanUtilNotNull.copyProperty(informeComercial, "nomAdministradorComunidad", comunidadPropietarios.getNomAdministrador());
				beanUtilNotNull.copyProperty(informeComercial, "telAdministradorComunidad", comunidadPropietarios.getTelfAdministrador());
			}

			// Datos del edificio.
			if (!Checks.esNulo(activo.getInfoComercial().getEdificio())) {
				// Reformas.
				beanUtilNotNull.copyProperty(informeComercial, "reformaFachada", activo.getInfoComercial().getEdificio().getReformaFachada());
				beanUtilNotNull.copyProperty(informeComercial, "reformaEscalera", activo.getInfoComercial().getEdificio().getReformaEscalera());
				beanUtilNotNull.copyProperty(informeComercial, "reformaPortal", activo.getInfoComercial().getEdificio().getReformaPortal());
				beanUtilNotNull.copyProperty(informeComercial, "reformaAscensor", activo.getInfoComercial().getEdificio().getReformaAscensor());
				beanUtilNotNull.copyProperty(informeComercial, "reformaCubierta", activo.getInfoComercial().getEdificio().getReformaCubierta());
				beanUtilNotNull.copyProperty(informeComercial, "reformaOtrasZonasComunes", activo.getInfoComercial().getEdificio().getReformaOtraZona());
				beanUtilNotNull.copyProperty(informeComercial, "reformaOtroDescEdificio", activo.getInfoComercial().getEdificio().getReformaOtroDescEdificio());

				// Inf general.
				if (!Checks.esNulo(activo.getInfoComercial().getEstadoConservacion())) {
					beanUtilNotNull.copyProperty(informeComercial, "estadoConservacionCodigo", activo.getInfoComercial().getEstadoConservacion().getCodigo());
				}

				if (!Checks.esNulo(activo.getInfoComercial().getEstadoConstruccion())) {
					beanUtilNotNull.copyProperty(informeComercial, "estadoConstruccionCodigo", activo.getInfoComercial().getEstadoConstruccion().getCodigo());
				}

				beanUtilNotNull.copyProperty(informeComercial, "numPlantas", activo.getInfoComercial().getEdificio().getNumPlantas());
				beanUtilNotNull.copyProperty(informeComercial, "ascensor", activo.getInfoComercial().getEdificio().getAscensor());
				beanUtilNotNull.copyProperty(informeComercial, "numAscensores", activo.getInfoComercial().getEdificio().getNumAscensores());
				beanUtilNotNull.copyProperty(informeComercial, "ediDescripcion", activo.getInfoComercial().getEdificio().getEdiDescripcion());
				beanUtilNotNull.copyProperty(informeComercial, "entornoInfraestructuras", activo.getInfoComercial().getEdificio().getEntornoInfraestructura());
				beanUtilNotNull.copyProperty(informeComercial, "entornoComunicaciones", activo.getInfoComercial().getEdificio().getEntornoComunicacion());
			}

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return informeComercial;
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
		DtoActivoInformeComercial activoInformeDto = (DtoActivoInformeComercial) webDto;

		try {
			// Se guardan todas las propieades del "Informe Comercial" que son comunes a
			// "Informacion Comercial"
			if (!Checks.esNulo(activo.getInfoComercial())) {
				beanUtilNotNull.copyProperties(activo.getInfoComercial(), activoInformeDto);

				if (!Checks.esNulo(activoInformeDto.getProvinciaCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getProvinciaCodigo());
					Filter borrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, filtro, borrado);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "provincia", provincia);
				}

				if (!Checks.esNulo(activoInformeDto.getMunicipioCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getMunicipioCodigo());
					Localidad localidad = (Localidad) genericDao.get(Localidad.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "localidad", localidad);
				}

				if (!Checks.esNulo(activoInformeDto.getTipoActivoCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getTipoActivoCodigo());
					DDTipoActivo tipoActivo = (DDTipoActivo) genericDao.get(DDTipoActivo.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "tipoActivo", tipoActivo);
				}

				if (!Checks.esNulo(activoInformeDto.getSubtipoActivoCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getSubtipoActivoCodigo());
					DDSubtipoActivo subtipoActivo = (DDSubtipoActivo) genericDao.get(DDSubtipoActivo.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "subtipoActivo", subtipoActivo);
				}

				if (!Checks.esNulo(activoInformeDto.getTipoViaCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getTipoViaCodigo());
					DDTipoVia tipoVia = (DDTipoVia) genericDao.get(DDTipoVia.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "tipoVia", tipoVia);
				}

				beanUtilNotNull.copyProperty(activo.getInfoComercial(), "numeroVia", activoInformeDto.getNumeroVia());
				beanUtilNotNull.copyProperty(activo.getInfoComercial(), "planta", activoInformeDto.getPlanta());

				if (!Checks.esNulo(activoInformeDto.getInferiorMunicipioCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getInferiorMunicipioCodigo());
					DDUnidadPoblacional unidadPoblacional = (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "unidadPoblacional", unidadPoblacional);
				}

				if (!Checks.esNulo(activoInformeDto.getUbicacionActivoCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getUbicacionActivoCodigo());
					DDUbicacionActivo ubicacionActivo = (DDUbicacionActivo) genericDao.get(DDUbicacionActivo.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "ubicacionActivo", ubicacionActivo);
				}

				if (!Checks.esNulo(activoInformeDto.getEstadoConstruccionCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoConstruccionCodigo());
					DDEstadoConstruccion estadoConstruccion = (DDEstadoConstruccion) genericDao.get(DDEstadoConstruccion.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "estadoConstruccion", estadoConstruccion);
				}

				if (!Checks.esNulo(activoInformeDto.getEstadoConservacionCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoConservacionCodigo());
					DDEstadoConservacion estadoConservacion = (DDEstadoConservacion) genericDao.get(DDEstadoConservacion.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "estadoConservacion", estadoConservacion);
				}

				// Datos del edificio.
				if (!Checks.esNulo(activo.getInfoComercial().getEdificio())) {
					// Reformas.
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaFachada", activoInformeDto.getReformaFachada());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaEscalera", activoInformeDto.getReformaEscalera());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaPortal", activoInformeDto.getReformaPortal());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaAscensor", activoInformeDto.getReformaAscensor());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaCubierta", activoInformeDto.getReformaCubierta());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaOtraZona", activoInformeDto.getReformaOtrasZonasComunes());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaOtroDescEdificio", activoInformeDto.getReformaOtroDescEdificio());

					// Inf general.
					if (!Checks.esNulo(activoInformeDto.getEstadoConservacionEdificioCodigo())) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoConservacionEdificioCodigo());
						DDEstadoConservacion estadoConservacion = (DDEstadoConservacion) genericDao.get(DDEstadoConservacion.class, filtro);
						beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "estadoConservacionEdificio", estadoConservacion);
					}

					if (!Checks.esNulo(activoInformeDto.getAnyoRehabilitacionEdificio())) {
						beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "anyoRehabilitacionEdificio",
								Integer.parseInt(activoInformeDto.getAnyoRehabilitacionEdificio()));
					}

					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "numPlantas", activoInformeDto.getNumPlantas());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "ascensor", activoInformeDto.getAscensor());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "numAscensores", activoInformeDto.getNumAscensores());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "ediDescripcion", activoInformeDto.getEdiDescripcion());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "entornoInfraestructura", activoInformeDto.getEntornoInfraestructuras());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "entornoComunicacion", activoInformeDto.getEntornoComunicaciones());
					
					//Datos de la propiedad de comunitarios
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "existeComunidadEdificio", activoInformeDto.getInscritaComunidad());
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "derramaOrientativaComunidad", activoInformeDto.getDerramaOrientativaComunidad());
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "cuotaOrientativaComunidad", activoInformeDto.getCuotaOrientativaComunidad());
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "nombrePresidenteComunidadEdificio", activoInformeDto.getNomPresidenteComunidad());
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "telefonoAdministradorComunidadEdificio", activoInformeDto.getTelAdministradorComunidad());
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "nombreAdministradorComunidadEdificio", activoInformeDto.getNomAdministradorComunidad());
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "telefonoPresidenteComunidadEdificio", activoInformeDto.getTelPresidenteComunidad());
				}

				activo.setInfoComercial(genericDao.save(ActivoInfoComercial.class, activo.getInfoComercial()));
			}

			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return activo;
	}

	private void getDatosByTipoActivo(Activo activo, DtoActivoInformeComercial activoInformeDto) {
		try {
			String codigoTipoActivo = null;

			if (!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getTipoActivo())
					&& !Checks.esNulo(activo.getInfoComercial().getTipoActivo().getCodigo())) {
				codigoTipoActivo = activo.getInfoComercial().getTipoActivo().getCodigo();
			} else {
				codigoTipoActivo = activo.getTipoActivo().getCodigo();
			}

			switch (Integer.parseInt(codigoTipoActivo)) {
				case 1:
					break;
				case 2:
					ActivoVivienda vivienda = (ActivoVivienda) activo.getInfoComercial();
					beanUtilNotNull.copyProperties(activoInformeDto, vivienda);
					break;
				case 3:
					ActivoLocalComercial local = (ActivoLocalComercial) activo.getInfoComercial();
					beanUtilNotNull.copyProperties(activoInformeDto, local);
					beanUtilNotNull.copyProperties(activoInformeDto, activo.getInfoComercial().getInstalacion());
					break;
				case 4:
					break;
				case 5:
					ActivoEdificio edificio = activo.getInfoComercial().getEdificio();
					beanUtilNotNull.copyProperties(activoInformeDto, edificio);
					break;
				case 6:
					break;
				case 7:
					ActivoPlazaAparcamiento otros = (ActivoPlazaAparcamiento) activo.getInfoComercial();
					beanUtilNotNull.copyProperties(activoInformeDto, otros);
					if (!Checks.esNulo(otros.getTipoCalidad())) beanUtilNotNull.copyProperty(activoInformeDto, "maniobrabilidadCodigo", otros.getTipoCalidad().getCodigo());
					if (!Checks.esNulo(otros.getSubtipoPlazagaraje()))
						beanUtilNotNull.copyProperty(activoInformeDto, "subtipoPlazagarajeCodigo", otros.getSubtipoPlazagaraje().getCodigo());
					// Instalaciones
					beanUtilNotNull.copyProperties(activoInformeDto, activo.getInfoComercial().getInstalacion());
					break;
				default:
					break;
			}

		} catch (ClassCastException e) {
			logger.error(e.getMessage());
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
	}
}