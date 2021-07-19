package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoBanyo;
import es.pfsgroup.plugin.rem.model.ActivoCarpinteriaExterior;
import es.pfsgroup.plugin.rem.model.ActivoCarpinteriaInterior;
import es.pfsgroup.plugin.rem.model.ActivoCocina;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoInfraestructura;
import es.pfsgroup.plugin.rem.model.ActivoInstalacion;
import es.pfsgroup.plugin.rem.model.ActivoLlave;
import es.pfsgroup.plugin.rem.model.ActivoLocalComercial;
import es.pfsgroup.plugin.rem.model.ActivoParamentoVertical;
import es.pfsgroup.plugin.rem.model.ActivoPlazaAparcamiento;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoSolado;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.ActivoZonaComun;
import es.pfsgroup.plugin.rem.model.DtoActivoInformeComercial;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConstruccion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVivienda;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSiniSiNoIndiferente;

@Component
public class TabActivoInformeComercial implements TabActivoService {

	protected static final Log logger = LogFactory.getLog(ActivoManager.class);

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GestorActivoApi gestorActivoManager;

	@Autowired
	private TabActivoFactoryApi tabActivoFactory;
	
	@Autowired
	private ActivoApi activoApi;
	

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	// Patrón para validar el email
    Pattern pattern = Pattern
            .compile("^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
                    + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$");
	private ApiProxyFactory proxyFactory;

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
					beanUtilNotNull.copyProperty(informeComercial, "provinciaDescripcion", activo.getInfoComercial().getProvincia().getDescripcion());
				}

				if (!Checks.esNulo(activo.getInfoComercial().getLocalidad())) {
					beanUtilNotNull.copyProperty(informeComercial, "municipioCodigo", activo.getInfoComercial().getLocalidad().getCodigo());
					beanUtilNotNull.copyProperty(informeComercial, "municipioDescripcion", activo.getInfoComercial().getLocalidad().getDescripcion());
				}

				if (!Checks.esNulo(activo.getInfoComercial().getTipoActivo())) {
					beanUtilNotNull.copyProperty(informeComercial, "tipoActivoCodigo", activo.getInfoComercial().getTipoActivo().getCodigo());
					beanUtilNotNull.copyProperty(informeComercial, "tipoActivoDescripcion", activo.getInfoComercial().getTipoActivo().getDescripcion());

					// Segun el tipo de activo, recuperaremos unos u otros datos
					this.getDatosByTipoActivo(activo, informeComercial);
				}

				if (!Checks.esNulo(activo.getInfoComercial().getSubtipoActivo())) {
					beanUtilNotNull.copyProperty(informeComercial, "subtipoActivoCodigo", activo.getInfoComercial().getSubtipoActivo().getCodigo());
					beanUtilNotNull.copyProperty(informeComercial, "subtipoActivoDescripcion", activo.getInfoComercial().getSubtipoActivo().getDescripcion());
				}

				if (!Checks.esNulo(activo.getInfoComercial().getTipoVia())) {
					beanUtilNotNull.copyProperty(informeComercial, "tipoViaCodigo", activo.getInfoComercial().getTipoVia().getCodigo());
					beanUtilNotNull.copyProperty(informeComercial, "tipoViaDescripcion", activo.getInfoComercial().getTipoVia().getDescripcion());
				}

				beanUtilNotNull.copyProperty(informeComercial, "numeroVia", activo.getInfoComercial().getNumeroVia());
				beanUtilNotNull.copyProperty(informeComercial, "planta", activo.getInfoComercial().getPlanta());

				if (!Checks.esNulo(activo.getInfoComercial().getUnidadPoblacional())) {
					beanUtilNotNull.copyProperty(informeComercial, "inferiorMunicipioCodigo", activo.getInfoComercial().getUnidadPoblacional().getCodigo());
					beanUtilNotNull.copyProperty(informeComercial, "inferiorMunicipioDescripcion", activo.getInfoComercial().getUnidadPoblacional().getDescripcion());
				}

				if (!Checks.esNulo(activo.getInfoComercial().getUbicacionActivo())) {
					beanUtilNotNull.copyProperty(informeComercial, "ubicacionActivoCodigo", activo.getInfoComercial().getUbicacionActivo().getCodigo());
				}
				
				Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo", activo);
				Order order = new Order(OrderType.DESC, "fechaRecepcion");
				
				// Datos del mediador (proveedor). La mayoria nos viene de el TabActivoInformacionComercial
				if (!Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
					
					Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "poseedor", activo.getInfoComercial().getMediadorInforme());
					
					List<ActivoLlave> llaves = genericDao.getListOrdered(ActivoLlave.class, order, filtroActivo, filtroProveedor);
					
					if(llaves != null && !llaves.isEmpty()) {
						informeComercial.setFechaRecepcionLlaves(llaves.get(0).getFechaRecepcion());
					}else if(llaves.isEmpty()) {
						informeComercial.setFechaRecepcionLlaves(null);
					}
					
					if(activo.getInfoComercial().getMediadorInforme().getAutorizacionWeb() != null){
						informeComercial.setAutorizacionWeb(activo.getInfoComercial().getMediadorInforme().getAutorizacionWeb());
					}else{
						informeComercial.setAutorizacionWeb(0);
					}
					
				}
				
				// Datos del mediador espejo (proveedor). La mayoria nos viene de el TabActivoInformacionComercial
				if(activo.getInfoComercial().getMediadorEspejo() != null) {
					
					Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "poseedor", activo.getInfoComercial().getMediadorEspejo());
					
					List<ActivoLlave> llaves = genericDao.getListOrdered(ActivoLlave.class, order, filtroActivo, filtroProveedor);
					
					if(llaves != null && !llaves.isEmpty()) {
						beanUtilNotNull.copyProperty(informeComercial, "fechaRecepcionLlavesEspejo", llaves.get(0).getFechaRecepcion());
					}
					
					if(activo.getInfoComercial().getMediadorEspejo().getAutorizacionWeb() != null){
						informeComercial.setAutorizacionWebEspejo(activo.getInfoComercial().getMediadorEspejo().getAutorizacionWeb());
					}else{
						informeComercial.setAutorizacionWebEspejo(0);
					}
				}
				
				//Informe mediador
				beanUtilNotNull.copyProperty(informeComercial, "posibleInforme", activo.getInfoComercial().getPosibleInforme());
				beanUtilNotNull.copyProperty(informeComercial, "posibleInformeBoolean", activo.getInfoComercial().getPosibleInforme());
				if (!Checks.esNulo(activo.getInfoComercial().getMotivoNoPosibleInforme())){
					beanUtilNotNull.copyProperty(informeComercial, "motivoNoPosibleInforme", activo.getInfoComercial().getMotivoNoPosibleInforme());
				}
				
				// Datos del proveedor tecnico.
				ActivoProveedor pve = gestorActivoManager.obtenerProveedorTecnico(activo.getId());
				
				if (!Checks.esNulo(pve)) {
					beanUtilNotNull.copyProperty(informeComercial, "tieneProveedorTecnico", true);
					if  (!activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_SAREB) && !activo.getSubcartera().getCodigo().equals(DDSubcartera.CODIGO_SAR_INMOBILIARIO)) 
					{
						beanUtilNotNull.copyProperty(informeComercial, "codigoProveedor", pve.getCodigoProveedorRem());
						beanUtilNotNull.copyProperty(informeComercial, "nombreProveedor", pve.getNombre());
					}
				}else{
					beanUtilNotNull.copyProperty(informeComercial, "tieneProveedorTecnico", false);
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
					beanUtilNotNull.copyProperty(informeComercial, "ascensor", activo.getInfoComercial().getEdificio().getAscensorEdificio());
					beanUtilNotNull.copyProperty(informeComercial, "numAscensores", activo.getInfoComercial().getEdificio().getNumAscensores());
					beanUtilNotNull.copyProperty(informeComercial, "ediDescripcion", activo.getInfoComercial().getEdificio().getEdiDescripcion());
					beanUtilNotNull.copyProperty(informeComercial, "entornoInfraestructuras", activo.getInfoComercial().getEdificio().getEntornoInfraestructura());
					beanUtilNotNull.copyProperty(informeComercial, "entornoComunicaciones", activo.getInfoComercial().getEdificio().getEntornoComunicacion());
					
					//terrazas
					beanUtilNotNull.copyProperty(informeComercial, "numTerrazaCubierta", activo.getInfoComercial().getNumeroTerrazasCubiertas());
					beanUtilNotNull.copyProperty(informeComercial, "descTerrazaCubierta", activo.getInfoComercial().getDescripcionTerrazasCubiertas());
					beanUtilNotNull.copyProperty(informeComercial, "numTerrazaDescubierta", activo.getInfoComercial().getNumeroTerrazasDescubiertas());
					beanUtilNotNull.copyProperty(informeComercial, "descTerrazaDescubierta", activo.getInfoComercial().getDescripcionTerrazasDescubiertas());
					
					// otras dependencias
					if (!Checks.esNulo(activo.getInfoComercial().getDespensaOtrasDependencias())
							&& activo.getInfoComercial().getDespensaOtrasDependencias().equals(Integer.valueOf(1))) {
						beanUtilNotNull.copyProperty(informeComercial, "despensa", true);
					}
					if (!Checks.esNulo(activo.getInfoComercial().getLavaderoOtrasDependencias())
							&& activo.getInfoComercial().getLavaderoOtrasDependencias().equals(Integer.valueOf(1))) {
						beanUtilNotNull.copyProperty(informeComercial, "lavadero", true);
					}
					if (!Checks.esNulo(activo.getInfoComercial().getAzoteaOtrasDependencias())
							&& activo.getInfoComercial().getAzoteaOtrasDependencias().equals(Integer.valueOf(1))) {
						beanUtilNotNull.copyProperty(informeComercial, "azotea", true);
					}
					beanUtilNotNull.copyProperty(informeComercial, "descOtras", activo.getInfoComercial().getOtrosOtrasDependencias());
					
					// Otras características
					if (!Checks.esNulo(activo.getInfoComercial().getAdmiteMascotaOtrasCaracteristicas())) {
						beanUtilNotNull.copyProperty(informeComercial, "admiteMascotaCodigo", activo.getInfoComercial().getAdmiteMascotaOtrasCaracteristicas().getCodigo());
					}
				}
			}

			// Datos de la Comunidad de vecinos al Dto.
			if (!Checks.esNulo(activo.getComunidadPropietarios())) {
				// Comunidad inscrita = constituida.
				if(activo.getComunidadPropietarios() != null){
					beanUtilNotNull.copyProperty(informeComercial, "inscritaComunidad", activo.getComunidadPropietarios().getConstituida());
					// Nombre y telefono Presidente.
					beanUtilNotNull.copyProperty(informeComercial, "nomPresidenteComunidad", activo.getComunidadPropietarios().getNomPresidente());
					beanUtilNotNull.copyProperty(informeComercial, "telPresidenteComunidad", activo.getComunidadPropietarios().getTelfPresidente());
					// Nombre y telefono Administrador.
					beanUtilNotNull.copyProperty(informeComercial, "nomAdministradorComunidad", activo.getComunidadPropietarios().getNomAdministrador());
					beanUtilNotNull.copyProperty(informeComercial, "telAdministradorComunidad", activo.getComunidadPropietarios().getTelfAdministrador());
				}
				
				if(activo.getInfoComercial() != null){
					// Derrama de la comunidad.
					beanUtilNotNull.copyProperty(informeComercial, "derramaOrientativaComunidad", activo.getInfoComercial().getDerramaOrientativaComunidad());
					// Cuota de la comunidad, tomada del importe medio.
					beanUtilNotNull.copyProperty(informeComercial, "cuotaOrientativaComunidad", activo.getInfoComercial().getCuotaOrientativaComunidad());
				}				
				
				
			}

			
			

			// HREOS-2761: Buscamos los campos que pueden ser propagados para esta pestaña
			if(!Checks.esNulo(activo) && activoDao.isActivoMatriz(activo.getId())) {	
				informeComercial.setCamposPropagablesUas(TabActivoService.TAB_INFORME_COMERCIAL);
			}else {
				// Buscamos los campos que pueden ser propagados para esta pestaña
				informeComercial.setCamposPropagables(TabActivoService.TAB_INFORME_COMERCIAL);
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
		ActivoInfoComercial actInfoComercial = null;
		ActivoVivienda vivienda = null;
		ActivoLocalComercial localComercial = null;
		ActivoPlazaAparcamiento plazaAparcamiento = null;
		try {
			// Se guardan todas las propieades del "Informe Comercial" que son comunes a
			// "Informacion Comercial"
			
			if (Checks.esNulo(activo.getInfoComercial())){
				actInfoComercial = new ActivoInfoComercial();
				actInfoComercial.setActivo(activo);								
				
				ActivoEdificio actEdificio = new ActivoEdificio();				
				actInfoComercial.setEdificio(actEdificio);
				actEdificio.setInfoComercial(actInfoComercial);
				activo.setInfoComercial(actInfoComercial);
				
				genericDao.save(ActivoEdificio.class, actEdificio);
			}else {
				actInfoComercial = activo.getInfoComercial();
			}
			if (!Checks.esNulo(actInfoComercial)) {
											
				beanUtilNotNull.copyProperties(actInfoComercial, activoInformeDto);
				if(activoInformeDto.getDistribucionTxt()!=null) {
					actInfoComercial.setInfoDistribucionInterior(activoInformeDto.getDistribucionTxt());	
				}
				
				if(actInfoComercial.getId() != null) {
					vivienda = genericDao.get(ActivoVivienda.class, genericDao.createFilter(FilterType.EQUALS, "informeComercial.id", actInfoComercial.getId()));
					localComercial = genericDao.get(ActivoLocalComercial.class, genericDao.createFilter(FilterType.EQUALS, "informeComercial.id", actInfoComercial.getId()));
					plazaAparcamiento = genericDao.get(ActivoPlazaAparcamiento.class, genericDao.createFilter(FilterType.EQUALS, "informeComercial.id", actInfoComercial.getId()));
					if(vivienda != null)
						beanUtilNotNull.copyProperties(vivienda, activoInformeDto);
					if(localComercial != null)
						beanUtilNotNull.copyProperties(localComercial, activoInformeDto);
					if(plazaAparcamiento != null)
						beanUtilNotNull.copyProperties(plazaAparcamiento, activoInformeDto);
				}				

				if (!Checks.esNulo(activoInformeDto.getProvinciaCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getProvinciaCodigo());
					Filter borrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, filtro, borrado);
					beanUtilNotNull.copyProperty(actInfoComercial, "provincia", provincia);
				}

				if (!Checks.esNulo(activoInformeDto.getMunicipioCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getMunicipioCodigo());
					Localidad localidad = (Localidad) genericDao.get(Localidad.class, filtro);
					beanUtilNotNull.copyProperty(actInfoComercial, "localidad", localidad);
				}

				if (!Checks.esNulo(activoInformeDto.getTipoActivoCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getTipoActivoCodigo());
					DDTipoActivo tipoActivo = (DDTipoActivo) genericDao.get(DDTipoActivo.class, filtro);
					beanUtilNotNull.copyProperty(actInfoComercial, "tipoActivo", tipoActivo);
				} else if (!Checks.esNulo(activo.getTipoActivo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activo.getTipoActivo().getCodigo());
					DDTipoActivo tipoActivo = (DDTipoActivo) genericDao.get(DDTipoActivo.class, filtro);
					beanUtilNotNull.copyProperty(actInfoComercial, "tipoActivo", tipoActivo);
				}

				if (!Checks.esNulo(activoInformeDto.getSubtipoActivoCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getSubtipoActivoCodigo());
					DDSubtipoActivo subtipoActivo = (DDSubtipoActivo) genericDao.get(DDSubtipoActivo.class, filtro);
					beanUtilNotNull.copyProperty(actInfoComercial, "subtipoActivo", subtipoActivo);
				} else if (!Checks.esNulo(activo.getSubtipoActivo())){
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activo.getSubtipoActivo().getCodigo());
					DDSubtipoActivo subtipoActivo = (DDSubtipoActivo) genericDao.get(DDSubtipoActivo.class, filtro);
					beanUtilNotNull.copyProperty(actInfoComercial, "subtipoActivo", subtipoActivo);
				}

				if (!Checks.esNulo(activoInformeDto.getTipoViaCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getTipoViaCodigo());
					DDTipoVia tipoVia = (DDTipoVia) genericDao.get(DDTipoVia.class, filtro);
					beanUtilNotNull.copyProperty(actInfoComercial, "tipoVia", tipoVia);
				}

				beanUtilNotNull.copyProperty(actInfoComercial, "numeroVia", activoInformeDto.getNumeroVia());
				beanUtilNotNull.copyProperty(actInfoComercial, "planta", activoInformeDto.getPlanta());

				if (!Checks.esNulo(activoInformeDto.getInferiorMunicipioCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getInferiorMunicipioCodigo());
					DDUnidadPoblacional unidadPoblacional = (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class, filtro);
					beanUtilNotNull.copyProperty(actInfoComercial, "unidadPoblacional", unidadPoblacional);
				}

				if (!Checks.esNulo(activoInformeDto.getUbicacionActivoCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getUbicacionActivoCodigo());
					DDUbicacionActivo ubicacionActivo = (DDUbicacionActivo) genericDao.get(DDUbicacionActivo.class, filtro);
					beanUtilNotNull.copyProperty(actInfoComercial, "ubicacionActivo", ubicacionActivo);
				}

				if (!Checks.esNulo(activoInformeDto.getEstadoConstruccionCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoConstruccionCodigo());
					DDEstadoConstruccion estadoConstruccion = (DDEstadoConstruccion) genericDao.get(DDEstadoConstruccion.class, filtro);
					beanUtilNotNull.copyProperty(actInfoComercial, "estadoConstruccion", estadoConstruccion);
				}

				if (!Checks.esNulo(activoInformeDto.getEstadoConservacionCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoConservacionCodigo());
					DDEstadoConservacion estadoConservacion = (DDEstadoConservacion) genericDao.get(DDEstadoConservacion.class, filtro);
					beanUtilNotNull.copyProperty(actInfoComercial, "estadoConservacion", estadoConservacion);
				}
				
				//Informe Mediador
				if (!Checks.esNulo(activoInformeDto.getPosibleInforme())){
					beanUtilNotNull.copyProperty(actInfoComercial, "posibleInforme", activoInformeDto.getPosibleInforme());
						if (activoInformeDto.getPosibleInforme() == 1){
							beanUtilNotNull.copyProperty(actInfoComercial, "motivoNoPosibleInforme", " ");
						} else {
							if (!Checks.esNulo(activoInformeDto.getMotivoNoPosibleInforme())){
								beanUtilNotNull.copyProperty(actInfoComercial, "motivoNoPosibleInforme", activoInformeDto.getMotivoNoPosibleInforme());
							}
						}
				}

				// Datos del edificio. Si el edificio es nulo, creamos registro en la tabla 
				if (Checks.esNulo(actInfoComercial.getEdificio())) {
					actInfoComercial.setEdificio(crearRegistroEdificio(activoInformeDto, activo));
				}else {
					// Reformas.
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "reformaFachada", activoInformeDto.getReformaFachada());
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "reformaEscalera", activoInformeDto.getReformaEscalera());
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "reformaPortal", activoInformeDto.getReformaPortal());
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "reformaAscensor", activoInformeDto.getReformaAscensor());
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "reformaCubierta", activoInformeDto.getReformaCubierta());
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "reformaOtraZona", activoInformeDto.getReformaOtrasZonasComunes());
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "reformaOtroDescEdificio", activoInformeDto.getReformaOtroDescEdificio());
	
					// Inf general.
					if (!Checks.esNulo(activoInformeDto.getEstadoConservacionEdificioCodigo())) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoConservacionEdificioCodigo());
						DDEstadoConservacion estadoConservacion = (DDEstadoConservacion) genericDao.get(DDEstadoConservacion.class, filtro);
						beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "estadoConservacionEdificio", estadoConservacion);
					}
	
					if (!Checks.esNulo(activoInformeDto.getAnyoRehabilitacionEdificio())) {
						beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "anyoRehabilitacionEdificio",
								Integer.parseInt(activoInformeDto.getAnyoRehabilitacionEdificio()));
					}
	
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "numPlantas", activoInformeDto.getNumPlantas());
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "ascensorEdificio", activoInformeDto.getAscensor());
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "numAscensores", activoInformeDto.getNumAscensores());
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "ediDescripcion", activoInformeDto.getEdiDescripcion());
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "entornoInfraestructura", activoInformeDto.getEntornoInfraestructuras());
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "entornoComunicacion", activoInformeDto.getEntornoComunicaciones());
					beanUtilNotNull.copyProperty(actInfoComercial.getEdificio(), "edificioDescPlantas", activoInformeDto.getEdificioDescPlantas());
				
				}
					
				//Datos de la propiedad de comunitarios
				beanUtilNotNull.copyProperty(actInfoComercial, "existeComunidadEdificio", activoInformeDto.getInscritaComunidad());
				beanUtilNotNull.copyProperty(actInfoComercial, "derramaOrientativaComunidad", activoInformeDto.getDerramaOrientativaComunidad());
				beanUtilNotNull.copyProperty(actInfoComercial, "cuotaOrientativaComunidad", activoInformeDto.getCuotaOrientativaComunidad());
				beanUtilNotNull.copyProperty(actInfoComercial, "nombrePresidenteComunidadEdificio", activoInformeDto.getNomPresidenteComunidad());
				beanUtilNotNull.copyProperty(actInfoComercial, "telefonoAdministradorComunidadEdificio", activoInformeDto.getTelAdministradorComunidad());
				beanUtilNotNull.copyProperty(actInfoComercial, "nombreAdministradorComunidadEdificio", activoInformeDto.getNomAdministradorComunidad());
				beanUtilNotNull.copyProperty(actInfoComercial, "telefonoPresidenteComunidadEdificio", activoInformeDto.getTelPresidenteComunidad());
					
					
				//terrazas
				beanUtilNotNull.copyProperty(actInfoComercial, "numeroTerrazasCubiertas", activoInformeDto.getNumTerrazaCubierta());
				beanUtilNotNull.copyProperty(actInfoComercial, "descripcionTerrazasCubiertas", activoInformeDto.getDescTerrazaCubierta());
				beanUtilNotNull.copyProperty(actInfoComercial, "numeroTerrazasDescubiertas", activoInformeDto.getNumTerrazaDescubierta());
				beanUtilNotNull.copyProperty(actInfoComercial, "descripcionTerrazasDescubiertas", activoInformeDto.getDescTerrazaDescubierta());
					
					
					
					//otras dependencias
					if(activoInformeDto.getDespensa() != null){
						if(activoInformeDto.getDespensa()){
							beanUtilNotNull.copyProperty(actInfoComercial, "despensaOtrasDependencias", Integer.valueOf(1));
						}else{
							beanUtilNotNull.copyProperty(actInfoComercial, "despensaOtrasDependencias", Integer.valueOf(0));
						}
					}
					if(activoInformeDto.getLavadero() != null){
						if(activoInformeDto.getLavadero()){
							beanUtilNotNull.copyProperty(actInfoComercial, "lavaderoOtrasDependencias", Integer.valueOf(1));
						}else{
							beanUtilNotNull.copyProperty(actInfoComercial, "lavaderoOtrasDependencias", Integer.valueOf(0));
						}
					}
					if(activoInformeDto.getAzotea() != null){
						if(activoInformeDto.getAzotea()){
							beanUtilNotNull.copyProperty(actInfoComercial, "azoteaOtrasDependencias", Integer.valueOf(1));
						}else{
							beanUtilNotNull.copyProperty(actInfoComercial, "azoteaOtrasDependencias", Integer.valueOf(0));
						}
					}
					beanUtilNotNull.copyProperty(actInfoComercial, "otrosOtrasDependencias", activoInformeDto.getDescOtras());
					
				//Otras características
				if(activoInformeDto.getAdmiteMascotaCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getAdmiteMascotaCodigo());
					DDSiniSiNoIndiferente tipoAdmiteMascota = (DDSiniSiNoIndiferente) genericDao.get(DDSiniSiNoIndiferente.class, filtro);
					beanUtilNotNull.copyProperty(actInfoComercial, "admiteMascotaOtrasCaracteristicas", tipoAdmiteMascota);
				}
				
				//Vivienda
				if (actInfoComercial.getVivienda() != null && activoInformeDto.getTipoViviendaCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getTipoViviendaCodigo());
					DDTipoVivienda tipoVivienda = (DDTipoVivienda) genericDao.get(DDTipoVivienda.class, filtro);
					beanUtilNotNull.copyProperty(vivienda, "tipoVivienda", tipoVivienda);
				}

				// Datos de Infraestructura
				if (Checks.esNulo(actInfoComercial.getInfraestructura())) {
					ActivoInfraestructura infraestructura = new ActivoInfraestructura();
					infraestructura.setInfoComercial(actInfoComercial);
					actInfoComercial.setInfraestructura(infraestructura);
					genericDao.save(ActivoInfraestructura.class, infraestructura);
				}
				beanUtilNotNull.copyProperties(actInfoComercial.getInfraestructura(), activoInformeDto);
				
				// Datos de CarpinteriaInterior
				if (Checks.esNulo(actInfoComercial.getCarpinteriaInterior())) {
					ActivoCarpinteriaInterior carpInt = new ActivoCarpinteriaInterior();
					carpInt.setInfoComercial(actInfoComercial);
					actInfoComercial.setCarpinteriaInterior(carpInt);
					genericDao.save(ActivoCarpinteriaInterior.class, carpInt);
				}
				beanUtilNotNull.copyProperties(actInfoComercial.getCarpinteriaInterior(), activoInformeDto);

				// Datos de CarpinteriaExterior
				if (Checks.esNulo(actInfoComercial.getCarpinteriaExterior())) {
					ActivoCarpinteriaExterior carpExt = new ActivoCarpinteriaExterior();
					carpExt.setInfoComercial(actInfoComercial);
					actInfoComercial.setCarpinteriaExterior(carpExt);
					genericDao.save(ActivoCarpinteriaExterior.class, carpExt);
				}
				beanUtilNotNull.copyProperties(actInfoComercial.getCarpinteriaExterior(), activoInformeDto);

				// Datos de ParamentoVertical
				if (Checks.esNulo(actInfoComercial.getParamentoVertical())) {
					ActivoParamentoVertical paramentoVertical = new ActivoParamentoVertical();
					paramentoVertical.setInfoComercial(actInfoComercial);
					actInfoComercial.setParamentoVertical(paramentoVertical);
					genericDao.save(ActivoParamentoVertical.class, paramentoVertical);					
				}
				beanUtilNotNull.copyProperties(actInfoComercial.getParamentoVertical(), activoInformeDto);

				// Datos de Solado
				if (Checks.esNulo(actInfoComercial.getSolado())) {
					ActivoSolado solado = new ActivoSolado();
					solado.setInfoComercial(actInfoComercial);
					actInfoComercial.setSolado(solado);
					genericDao.save(ActivoSolado.class, solado);
				}
				beanUtilNotNull.copyProperties(actInfoComercial.getSolado(), activoInformeDto);

				// Datos de Cocina
				if (Checks.esNulo(actInfoComercial.getCocina())) {
					ActivoCocina cocina = new ActivoCocina();
					cocina.setInfoComercial(actInfoComercial);
					actInfoComercial.setCocina(cocina);
					genericDao.save(ActivoCocina.class, cocina);
				}
				beanUtilNotNull.copyProperties(actInfoComercial.getCocina(), activoInformeDto);

				// Datos de Banyo
				if (Checks.esNulo(actInfoComercial.getBanyo())) {
					ActivoBanyo banyo = new ActivoBanyo();
					banyo.setInfoComercial(actInfoComercial);
					actInfoComercial.setBanyo(banyo);
					genericDao.save(ActivoBanyo.class, banyo);
				}
				beanUtilNotNull.copyProperties(actInfoComercial.getBanyo(), activoInformeDto);

				// Datos de Instalacion
				if (Checks.esNulo(actInfoComercial.getInstalacion())) {
					ActivoInstalacion instalacion = new ActivoInstalacion();
					instalacion.setInfoComercial(actInfoComercial);
					actInfoComercial.setInstalacion(instalacion);
					genericDao.save(ActivoInstalacion.class, instalacion);
				}
				beanUtilNotNull.copyProperties(actInfoComercial.getInstalacion(), activoInformeDto);

				// Datos de ZonaComun
				if (Checks.esNulo(actInfoComercial.getZonaComun())) {
					ActivoZonaComun zonaComun = new ActivoZonaComun();
					zonaComun.setInfoComercial(actInfoComercial);
					actInfoComercial.setZonaComun(zonaComun);
					genericDao.save(ActivoZonaComun.class, zonaComun);
				}
				beanUtilNotNull.copyProperties(actInfoComercial.getZonaComun(), activoInformeDto);
				
				//// HREOS-3025 Valor estimado del mediador: No se copia donde debe
				Boolean valorEstimadoVentaExists = false;
				Boolean valorEstimadoRentaExists = false;
				
				List<ActivoValoraciones> valoraciones = activo.getValoracion();
				if (!Checks.esNulo(valoraciones) || !Checks.estaVacio(valoraciones)) {
					for (ActivoValoraciones valoracion : valoraciones) {
						if (!Checks.esNulo(activoInformeDto.getValorEstimadoVenta())) {
							if (DDTipoPrecio.CODIGO_TPC_ESTIMADO_VENTA.equals(valoracion.getTipoPrecio().getCodigo())) {
								valoracion.setImporte(activoInformeDto.getValorEstimadoVenta());
								valorEstimadoVentaExists = true;
							}
						}
						if (!Checks.esNulo(activoInformeDto.getValorEstimadoRenta())) {
							if (DDTipoPrecio.CODIGO_TPC_ESTIMADO_RENTA.equals(valoracion.getTipoPrecio().getCodigo())) {
								valoracion.setImporte(activoInformeDto.getValorEstimadoRenta());
								valorEstimadoRentaExists = true;
							}
						}
					}
				}
				
				if(!valorEstimadoVentaExists && !Checks.esNulo(activoInformeDto.getValorEstimadoVenta())) {
					ActivoValoraciones valoracionEstimadoVenta = new ActivoValoraciones();
					valoracionEstimadoVenta.setImporte(activoInformeDto.getValorEstimadoVenta());
					valoracionEstimadoVenta.setAuditoria(Auditoria.getNewInstance());
					valoracionEstimadoVenta.setTipoPrecio((DDTipoPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPrecio.class, DDTipoPrecio.CODIGO_TPC_ESTIMADO_VENTA));
					valoracionEstimadoVenta.setActivo(activo);
					valoraciones.add(valoracionEstimadoVenta);
				}
			
				
				if(!valorEstimadoRentaExists && !Checks.esNulo(activoInformeDto.getValorEstimadoRenta())) {
					ActivoValoraciones valoracionEstimadoRenta = new ActivoValoraciones();
					valoracionEstimadoRenta.setImporte(activoInformeDto.getValorEstimadoRenta());
					valoracionEstimadoRenta.setAuditoria(Auditoria.getNewInstance());
					valoracionEstimadoRenta.setTipoPrecio((DDTipoPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPrecio.class, DDTipoPrecio.CODIGO_TPC_ESTIMADO_RENTA));
					valoracionEstimadoRenta.setActivo(activo);
					valoraciones.add(valoracionEstimadoRenta);
				}
				
			if(!Checks.esNulo(actInfoComercial.getPosibleInforme())) {
				if (actInfoComercial.getPosibleInforme() == 0) {
					Filter filterEstado = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_RECHAZO);
					DDEstadoInformeComercial estadoRechazado = genericDao.get(DDEstadoInformeComercial.class, filterEstado);
					
					ActivoEstadosInformeComercialHistorico historico = new ActivoEstadosInformeComercialHistorico();
					historico.setActivo(activo);
					historico.setEstadoInformeComercial(estadoRechazado);
					historico.setFecha(new Date());
					if (!Checks.esNulo(actInfoComercial.getMotivoNoPosibleInforme())){
						historico.setMotivo(actInfoComercial.getMotivoNoPosibleInforme());
					}
					genericDao.save(ActivoEstadosInformeComercialHistorico.class, historico);
					
					//Creación y envio correo rechazo informe comercial
					String asunto = "No se ha podido realizar el informe comercial del activo " + activo.getNumActivo();
					String cuerpo = "No se ha podido realizar le informe comercial del activo " +activo.getNumActivo()+ ", motivo: "+actInfoComercial.getMotivoNoPosibleInforme();
					
					DtoSendNotificator dtoSendNotificator = new DtoSendNotificator();
					dtoSendNotificator.setNumActivo(activo.getNumActivo());
					dtoSendNotificator.setDireccion(activo.getDireccion());
					
					List<String> mailsCC = new ArrayList<String>();
					
					String gestorPublicacion = extractEmail(gestorActivoApi.getGestorByActivoYTipo(activo, "GPUBL"));
					String supervisorPublicacion = extractEmail(gestorActivoApi.getGestorByActivoYTipo(activo, "SPUBL"));
					
					ArrayList<String> destinatarios = new ArrayList<String>();
					destinatarios.add(gestorPublicacion);
					destinatarios.add(supervisorPublicacion);
					
					String cuerpoCorreo = this.generateCuerpoCorreo(dtoSendNotificator, cuerpo);
					genericAdapter.sendMail(destinatarios, mailsCC, asunto, cuerpoCorreo);
				}
				
				activo.setValoracion(valoraciones);
				activo.setInfoComercial(actInfoComercial);
			
			}
			genericDao.save(ActivoInfoComercial.class, actInfoComercial);
			if(vivienda != null)
				genericDao.update(ActivoVivienda.class, vivienda);
			if(localComercial != null)
				genericDao.update(ActivoLocalComercial.class, localComercial);
			if(plazaAparcamiento != null)
				genericDao.update(ActivoPlazaAparcamiento.class, plazaAparcamiento);
			genericDao.save(ActivoInfoComercial.class, actInfoComercial);
			activoApi.saveOrUpdate(activo);
		}		

			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}

		return activo;
	}
	
	private ActivoEdificio crearRegistroEdificio(DtoActivoInformeComercial activoInformeDto, Activo activo) {
		ActivoEdificio edi = new ActivoEdificio();
		
		edi.setInfoComercial(activo.getInfoComercial());
		
		Auditoria auditoria = new Auditoria();
		auditoria.setFechaCrear(new Date());
		auditoria.setBorrado(false);
		auditoria.setUsuarioCrear(genericAdapter.getUsuarioLogado().getUsername());
		
		edi.setAuditoria(auditoria);
		
		// Reformas.
		try {
			beanUtilNotNull.copyProperty(edi, "reformaFachada", activoInformeDto.getReformaFachada());
			beanUtilNotNull.copyProperty(edi, "reformaEscalera", activoInformeDto.getReformaEscalera());
			beanUtilNotNull.copyProperty(edi, "reformaPortal", activoInformeDto.getReformaPortal());
			beanUtilNotNull.copyProperty(edi, "reformaAscensor", activoInformeDto.getReformaAscensor());
			beanUtilNotNull.copyProperty(edi, "reformaCubierta", activoInformeDto.getReformaCubierta());
			beanUtilNotNull.copyProperty(edi, "reformaOtraZona", activoInformeDto.getReformaOtrasZonasComunes());
			beanUtilNotNull.copyProperty(edi, "reformaOtroDescEdificio", activoInformeDto.getReformaOtroDescEdificio());
		
			// Inf general.
			if (!Checks.esNulo(activoInformeDto.getEstadoConservacionEdificioCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoConservacionEdificioCodigo());
				DDEstadoConservacion estadoConservacion = (DDEstadoConservacion) genericDao.get(DDEstadoConservacion.class, filtro);
				beanUtilNotNull.copyProperty(edi, "estadoConservacionEdificio", estadoConservacion);
			}
		
			if (!Checks.esNulo(activoInformeDto.getAnyoRehabilitacionEdificio())) {
				beanUtilNotNull.copyProperty(edi, "anyoRehabilitacionEdificio",
						Integer.parseInt(activoInformeDto.getAnyoRehabilitacionEdificio()));
			}
		
			beanUtilNotNull.copyProperty(edi, "numPlantas", activoInformeDto.getNumPlantas());
			beanUtilNotNull.copyProperty(edi, "ascensorEdificio", activoInformeDto.getAscensor());
			beanUtilNotNull.copyProperty(edi, "numAscensores", activoInformeDto.getNumAscensores());
			beanUtilNotNull.copyProperty(edi, "ediDescripcion", activoInformeDto.getEdiDescripcion());
			beanUtilNotNull.copyProperty(edi, "entornoInfraestructura", activoInformeDto.getEntornoInfraestructuras());
			beanUtilNotNull.copyProperty(edi, "entornoComunicacion", activoInformeDto.getEntornoComunicaciones());
			beanUtilNotNull.copyProperty(edi, "edificioDescPlantas", activoInformeDto.getEdificioDescPlantas());
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		genericDao.save(ActivoEdificio.class, edi);
		
		return edi;
	}

	private void getDatosByTipoActivo(Activo activo, DtoActivoInformeComercial activoInformeDto) {
		try {
			String codigoTipoActivo = null;
			if(activo.getInfoComercial() != null) {
				ActivoVivienda vivienda = genericDao.get(ActivoVivienda.class, genericDao.createFilter(FilterType.EQUALS, "informeComercial.id", activo.getInfoComercial().getId()));
				ActivoLocalComercial localComercial = genericDao.get(ActivoLocalComercial.class, genericDao.createFilter(FilterType.EQUALS, "informeComercial.id", activo.getInfoComercial().getId()));
				ActivoPlazaAparcamiento plazaAparcamiento = genericDao.get(ActivoPlazaAparcamiento.class, genericDao.createFilter(FilterType.EQUALS, "informeComercial.id", activo.getInfoComercial().getId()));
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
					if (vivienda != null) {
						beanUtilNotNull.copyProperties(activoInformeDto, activo.getInfoComercial());
						beanUtilNotNull.copyProperties(activoInformeDto, vivienda);
					}
					break;
				case 3:
					if (localComercial != null) {
						beanUtilNotNull.copyProperties(activoInformeDto, activo.getInfoComercial());
						beanUtilNotNull.copyProperties(activoInformeDto, localComercial);
					}
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
					if (plazaAparcamiento != null) {
						beanUtilNotNull.copyProperties(activoInformeDto, activo.getInfoComercial());
						beanUtilNotNull.copyProperties(activoInformeDto, plazaAparcamiento);
						if (!Checks.esNulo(plazaAparcamiento.getTipoCalidad()))
							beanUtilNotNull.copyProperty(activoInformeDto, "maniobrabilidadCodigo",
									plazaAparcamiento.getTipoCalidad().getCodigo());
						if (!Checks.esNulo(plazaAparcamiento.getSubtipoPlazagaraje()))
							beanUtilNotNull.copyProperty(activoInformeDto, "subtipoPlazagarajeCodigo",
									plazaAparcamiento.getSubtipoPlazagaraje().getCodigo());
					}
					// Instalaciones
					if (activo.getInfoComercial().getInstalacion() != null) {
						beanUtilNotNull.copyProperties(activoInformeDto, activo.getInfoComercial().getInstalacion());
					}
					break;
				default:
					break;
				}
			}

		} catch (ClassCastException e) {
			logger.error(e.getMessage(), e);
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage(), e);
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage(), e);
		}
	}
	
	protected String generateCuerpoCorreo(DtoSendNotificator dtoSendNotificator, String contenido){
		String cuerpo = "<html>"
				+ "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
				+ "<html>"
				+ "<head>"
				+ "<META http-equiv='Content-Type' content='text/html; charset=utf-8'>"
				+ "</head>"
				+ "<body>"
				+ "	<div>"
				+ "		<div style='font-family: Arial,&amp; amp;'>"
				+ "			<div style='border-radius: 12px 12px 0px 0px; background: #b7ddf0; width: 300px; height: 60px; display: table'>"
				+ "				<img src='"+this.getUrlImagenes()+"ico_notificacion.png' "
				+ "					style='display: table-cell; padding: 12px; display: inline-block' />"
				+ "				<div style='font-size: 20px; vertical-align: top; color: #333; display: table-cell; padding: 12px'> " + dtoSendNotificator.getTitulo() + "</div>"
				+ "			</div>"
				+ "			<div style='background: #b7ddf0; width: 785px; min-height: 600px; border-radius: 0px 20px 20px 20px; padding: 20px'>"
				+ "				<div style='background: #054664; width: 600px; height: 375px; border-radius: 20px; color: #fff; display: inline-block'>"
				+ "					<div style='display: table; margin: 20px;'>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='"+this.getUrlImagenes()+"ico_activos.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Nº Activo: <strong>"+dtoSendNotificator.getNumActivo()+"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "						<div style='display: table-row;'>"
				+ "							<div style='display: table-cell; vertical-align: middle; padding: 10px;'>"
				+ "								<img src='"+this.getUrlImagenes()+"ico_direccion.png' />"
				+ "							</div>"
				+ "							<div style='display: table-cell; vertical-align: middle; font-size: 16px;'>"
				+ "								Dirección: <strong>"+dtoSendNotificator.getDireccion()+"</strong>"
				+ "							</div>"
				+ "						</div>"
				+ "					</div>"
				+ "				</div>"			
				+ "				<div style='display: inline-block; width: 140px; vertical-align: top'>"
				+ "					<img src='"+this.getUrlImagenes()+"logo_haya.png' "
				+ "						style='display: block; margin: 30px auto' /> "
				+ "					<img src='"+this.getUrlImagenes()+"logo_rem.png' "
				+ "						style='display: block; margin: 30px auto' /> "
				+ "				</div>"
				+ "				<div style='background: #fff; color: #333; border-radius: 20px; padding: 25px; line-height: 22px; text-align: justify; margin-top: 20px; font-size: 16px'>"
				+ 					contenido
				+ "				</div>"
				+ "				<div style='color: #333; margin: 23px 0px 0px 65px; font-size: 16px; display: table;'>"
				+ "					<div style='display: table-cell'>"
				+ "						<img src='"+this.getUrlImagenes()+"ico_advertencia.png' />"
				+ "					</div>"			
				+ "					<div style='display: table-cell; vertical-align: middle; padding: 5px;'>"
				+ "						Este mensaje es una notificación automática. No responda a este correo.</div>"
				+ "				</div>"
				+ "			</div>"
				+ "		</div>"
				+ "</body>"
				+ "</html>";
		
		return cuerpo;
	}
	
	private String getUrlImagenes(){
		String url = appProperties.getProperty("url");
		
		return url+"/pfs/js/plugin/rem/resources/images/notificator/";
	}
	
	private String extractEmail(Usuario u) {
		String eMail = null;
		if (u != null) {
			if(u.getEmail() != null && !u.getEmail().isEmpty()){
				Matcher mather = pattern.matcher(u.getEmail());
				if( mather.find() == true){
					eMail = u.getEmail();
				}
			}
		}
		return eMail;
	}
}