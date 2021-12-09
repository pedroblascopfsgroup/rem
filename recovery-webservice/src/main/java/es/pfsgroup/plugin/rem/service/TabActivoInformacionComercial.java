package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoLlave;
import es.pfsgroup.plugin.rem.model.ActivoPlazaAparcamiento;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.DtoActivoInformacionComercial;
import es.pfsgroup.plugin.rem.model.DtoSendNotificator;
import es.pfsgroup.plugin.rem.model.dd.DDActivoAccesibilidad;
import es.pfsgroup.plugin.rem.model.dd.DDAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClasificacion;
import es.pfsgroup.plugin.rem.model.dd.DDDisponibilidad;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacionEdificio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConstruccion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoMobiliario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOcupacional;
import es.pfsgroup.plugin.rem.model.dd.DDExteriorInterior;
import es.pfsgroup.plugin.rem.model.dd.DDRatingCocina;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalefaccion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoClimatizacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFachada;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOrientacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPuerta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRenta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUbicaAparcamiento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVivienda;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDUsoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDValoracionUbicacion;
import es.pfsgroup.plugin.rem.thread.ConvivenciaAlaska;

import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.ModelMap;

import javax.annotation.Resource;

@Component
public class TabActivoInformacionComercial implements TabActivoService {
    
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GestorActivoApi gestorActivoManager;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Resource
	private Properties appProperties;
	
	// Patrón para validar el email
    Pattern pattern = Pattern
            .compile("^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
                    + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$");
	
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_INFORMACION_COMERCIAL};
	}
	
	
	/**
	 * Método que devuelve un DTO para la carga del modelo de Informe Comercial del Activo
	 * 
	 * @param Activo
	 * @return DtoActivoInformeComercial
	 */
	public DtoActivoInformacionComercial getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoInformacionComercial informeComercial = new DtoActivoInformacionComercial();
		
		ActivoInfoComercial activoInfoComercial = activo.getInfoComercial();

		if (!Checks.esNulo(activoInfoComercial)) {
			
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo", activo);
			Order order = new Order(OrderType.DESC, "fechaRecepcion");
			
			// Datos del mediador (proveedor). La mayoria nos viene de el TabActivoInformacionComercial
			if (!Checks.esNulo(activoInfoComercial.getMediadorInforme())) {
				
				Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "poseedor", activoInfoComercial.getMediadorInforme());
				
				List<ActivoLlave> llaves = genericDao.getListOrdered(ActivoLlave.class, order, filtroActivo, filtroProveedor);
				
				if(llaves != null && !llaves.isEmpty()) {
					informeComercial.setRecepcionLlavesApi(llaves.get(0).getFechaRecepcion());
				}else if(llaves.isEmpty()) {
					informeComercial.setRecepcionLlavesApi(null);
				}
				
				if(activoInfoComercial.getMediadorInforme().getAutorizacionWeb() != null){
					informeComercial.setAutorizacionWeb(activoInfoComercial.getMediadorInforme().getAutorizacionWeb() == 1 ? true : false);
					//fechaAutorizacionHasta
				}else{
					informeComercial.setAutorizacionWeb(false);
				}
				
				informeComercial.setCodigoMediador(activoInfoComercial.getMediadorInforme().getCodigoProveedorRem());
				informeComercial.setNombreMediador(activoInfoComercial.getMediadorInforme().getNombre());
				informeComercial.setEmailMediador(activoInfoComercial.getMediadorInforme().getEmail());
				informeComercial.setTelefonoMediador(activoInfoComercial.getMediadorInforme().getTelefono1());					
			}
			
			// Datos del mediador espejo (proveedor). La mayoria nos viene de el TabActivoInformacionComercial
			if(activoInfoComercial.getMediadorEspejo() != null) {
				
				Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "poseedor", activoInfoComercial.getMediadorEspejo());
				
				List<ActivoLlave> llaves = genericDao.getListOrdered(ActivoLlave.class, order, filtroActivo, filtroProveedor);
				
				if(llaves != null && !llaves.isEmpty()) {
					informeComercial.setRecepcionLlavesEspejo(llaves.get(0).getFechaRecepcion());
				}else if(llaves.isEmpty()) {
					informeComercial.setRecepcionLlavesEspejo(null);
				}
				
				if(activoInfoComercial.getMediadorEspejo().getAutorizacionWeb() != null){
					informeComercial.setAutorizacionWebEspejo(activoInfoComercial.getMediadorEspejo().getAutorizacionWeb() == 1 ? true : false);
				}else{
					informeComercial.setAutorizacionWebEspejo(false);
				}
				
				informeComercial.setCodigoMediadorEspejo(activoInfoComercial.getMediadorEspejo().getCodigoProveedorRem());
				informeComercial.setNombreMediadorEspejo(activoInfoComercial.getMediadorEspejo().getNombre());
				informeComercial.setEmailMediadorEspejo(activoInfoComercial.getMediadorEspejo().getEmail());
				informeComercial.setTelefonoMediadorEspejo(activoInfoComercial.getMediadorEspejo().getTelefono1());	
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
			
			informeComercial.setNumeroActivo(activo.getNumActivo().toString());
			if (!Checks.esNulo(activoInfoComercial.getDescripcionComercial())) 
				informeComercial.setDescripcionComercial(activoInfoComercial.getDescripcionComercial());
			if (!Checks.esNulo(activoInfoComercial.getFechaUltimaVisita())) 
				informeComercial.setFechaVisita(activoInfoComercial.getFechaUltimaVisita());
			if (!Checks.esNulo(activoInfoComercial.getEnvioLlavesApi())) 
				informeComercial.setEnvioLlavesApi(activoInfoComercial.getEnvioLlavesApi());
			
			//Direccion
			if (!Checks.esNulo(activoInfoComercial.getSubtipoActivo())) {
				informeComercial.setTipoActivoCodigo(activoInfoComercial.getSubtipoActivo().getTipoActivo().getCodigo());
				informeComercial.setTipoActivoDescripcion(activoInfoComercial.getSubtipoActivo().getTipoActivo().getDescripcion());
				informeComercial.setSubtipoActivoCodigo(activoInfoComercial.getSubtipoActivo().getCodigo());
				informeComercial.setSubtipoActivoDescripcion(activoInfoComercial.getSubtipoActivo().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getTipoVia())) {
				informeComercial.setTipoViaCodigo(activoInfoComercial.getTipoVia().getCodigo());
				informeComercial.setTipoViaDescripcion(activoInfoComercial.getTipoVia().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getNombreVia()))
				informeComercial.setNombreVia(activoInfoComercial.getNombreVia());
			if (!Checks.esNulo(activoInfoComercial.getEscalera()))
				informeComercial.setEscalera(activoInfoComercial.getEscalera());
			if (!Checks.esNulo(activoInfoComercial.getPlanta()))
				informeComercial.setPiso(activoInfoComercial.getPlanta());
			if (!Checks.esNulo(activoInfoComercial.getPuerta()))
				informeComercial.setPuerta(activoInfoComercial.getPuerta());
			if (!Checks.esNulo(activoInfoComercial.getProvincia())) {
				informeComercial.setProvinciaCodigo(activoInfoComercial.getProvincia().getCodigo());
				informeComercial.setProvinciaDescripcion(activoInfoComercial.getProvincia().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getLocalidad())) {
				informeComercial.setMunicipioCodigo(activoInfoComercial.getLocalidad().getCodigo());
				informeComercial.setMunicipioDescripcion(activoInfoComercial.getLocalidad().getDescripcion());
			}
			//informeComercial.setInferiorMunicipioCodigo();
			//informeComercial.setInferiorMunicipioDescripcion();
			if (!Checks.esNulo(activoInfoComercial.getCodigoPostal())) 
				informeComercial.setCodPostal(activoInfoComercial.getCodigoPostal());
			if (!Checks.esNulo(activoInfoComercial.getLatitud())) 
				informeComercial.setLatitud(activoInfoComercial.getLatitud().toString());
			if (!Checks.esNulo(activoInfoComercial.getLongitud())) 
				informeComercial.setLongitud(activoInfoComercial.getLongitud().toString());
			//informeComercial.setPosibleInforme();
			//informeComercial.setMotivoNoPosibleInforme();
			//informeComercial.setUbicacionActivoCodigo();
			//informeComercial.setUbicacionActivoDescripcion();
			//informeComercial.setDistrito();
			
			//Informacion general
			if (!Checks.esNulo(activoInfoComercial.getRegimenProteccion())) {
				informeComercial.setRegimenInmuebleCod(activoInfoComercial.getRegimenProteccion().getCodigo());
				informeComercial.setRegimenInmuebleDesc(activoInfoComercial.getRegimenProteccion().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getEstadoOcupacional())) {
				informeComercial.setEstadoOcupacionalCod(activoInfoComercial.getEstadoOcupacional().getCodigo());
				informeComercial.setEstadoOcupacionalDesc(activoInfoComercial.getEstadoOcupacional().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getAnyoConstruccion())) 
				informeComercial.setAnyoConstruccion(activoInfoComercial.getAnyoConstruccion());
			
			//Caracteristicas del activo
			if (!Checks.esNulo(activoInfoComercial.getVisitable())) {
				informeComercial.setVisitableCod(activoInfoComercial.getVisitable().getCodigo());
				informeComercial.setVisitableDesc(activoInfoComercial.getVisitable().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getOcupado())) {
				informeComercial.setOcupadoCod(activoInfoComercial.getOcupado().getCodigo());
				informeComercial.setOcupadoDesc(activoInfoComercial.getOcupado().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getNumDormitorios())) 
				informeComercial.setDormitorios(activoInfoComercial.getNumDormitorios().intValue());
			if (!Checks.esNulo(activoInfoComercial.getNumBanyos())) 
				informeComercial.setBanyos(activoInfoComercial.getNumBanyos().intValue());
			if (!Checks.esNulo(activoInfoComercial.getNumAseos()))
				informeComercial.setAseos(activoInfoComercial.getNumAseos().intValue());
			if (!Checks.esNulo(activoInfoComercial.getNumSalones()))
				informeComercial.setSalones(activoInfoComercial.getNumSalones().intValue());
			if (!Checks.esNulo(activoInfoComercial.getNumEstancias()))
				informeComercial.setEstancias(activoInfoComercial.getNumEstancias().intValue());
			if (!Checks.esNulo(activoInfoComercial.getNumPlantas()))
				informeComercial.setPlantas(activoInfoComercial.getNumPlantas().intValue());
			if (!Checks.esNulo(activoInfoComercial.getAscensor())) {
				informeComercial.setAscensorCod(activoInfoComercial.getAscensor().getCodigo());
				informeComercial.setAscensorDesc(activoInfoComercial.getAscensor().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getNumGaraje())) 
				informeComercial.setPlazasGaraje(activoInfoComercial.getNumGaraje().intValue());
			if (!Checks.esNulo(activoInfoComercial.getTerraza())) {
				informeComercial.setTerrazaCod(activoInfoComercial.getTerraza().getCodigo());
				informeComercial.setTerrazaDesc(activoInfoComercial.getTerraza().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getSuperficieTerraza())) 
				informeComercial.setSuperficieTerraza(activoInfoComercial.getSuperficieTerraza().doubleValue());
			if (!Checks.esNulo(activoInfoComercial.getPatio())) {
				informeComercial.setPatioCod(activoInfoComercial.getPatio().getCodigo());
				informeComercial.setPatioDesc(activoInfoComercial.getPatio().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getSuperficiePatio())) 
				informeComercial.setSuperficiePatio(activoInfoComercial.getSuperficiePatio().doubleValue());
			if (!Checks.esNulo(activoInfoComercial.getRehabilitado())) {
				informeComercial.setRehabilitadoCod(activoInfoComercial.getRehabilitado().getCodigo());
				informeComercial.setRehabilitadoDesc(activoInfoComercial.getRehabilitado().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getAnyoRehabilitacion())) 
				informeComercial.setAnyoRehabilitacion(activoInfoComercial.getAnyoRehabilitacion());
			if (!Checks.esNulo(activoInfoComercial.getEstadoConservacion())) {
				informeComercial.setEstadoConservacionCod(activoInfoComercial.getEstadoConservacion().getCodigo());
				informeComercial.setEstadoConservacionDesc(activoInfoComercial.getEstadoConservacion().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getAnejoGaraje())) {
				informeComercial.setAnejoGarajeCod(activoInfoComercial.getAnejoGaraje().getCodigo());
				informeComercial.setAnejoGarajeDesc(activoInfoComercial.getAnejoGaraje().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getAnejoTrastero())) {
				informeComercial.setAnejoTrasteroCod(activoInfoComercial.getAnejoTrastero().getCodigo());
				informeComercial.setAnejoTrasteroDesc(activoInfoComercial.getAnejoTrastero().getDescripcion());
			}
			
			//Caracteristicas ppales del activo
			if (!Checks.esNulo(activoInfoComercial.getOrientacion())) 
				informeComercial.setOrientacion(activoInfoComercial.getOrientacion());
			if (!Checks.esNulo(activoInfoComercial.getExteriorInterior())) {
				informeComercial.setExtIntCod(activoInfoComercial.getExteriorInterior().getCodigo());
				informeComercial.setExtIntDesc(activoInfoComercial.getExteriorInterior().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getRatingCocina())) {
				informeComercial.setCocRatingCod(activoInfoComercial.getRatingCocina().getCodigo());
				informeComercial.setCocRatingDesc(activoInfoComercial.getRatingCocina().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getCocinaAmueblada())) {
				informeComercial.setCocAmuebladaCod(activoInfoComercial.getCocinaAmueblada().getCodigo());
				informeComercial.setCocAmuebladaDesc(activoInfoComercial.getCocinaAmueblada().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getArmariosEmpotrados())) {
				informeComercial.setArmEmpotradosCod(activoInfoComercial.getArmariosEmpotrados().getCodigo());
				informeComercial.setArmEmpotradosDesc(activoInfoComercial.getArmariosEmpotrados().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getCalefaccion())) 
				informeComercial.setCalefaccion(activoInfoComercial.getCalefaccion());
			if (!Checks.esNulo(activoInfoComercial.getTipoCalefaccion())) {
				informeComercial.setTipoCalefaccionCod(activoInfoComercial.getTipoCalefaccion().getCodigo());
				informeComercial.setTipoCalefaccionDesc(activoInfoComercial.getTipoCalefaccion().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getAireAcondicionado())) {
				informeComercial.setAireAcondCod(activoInfoComercial.getAireAcondicionado().getCodigo());
				informeComercial.setAireAcondDesc(activoInfoComercial.getAireAcondicionado().getDescripcion());
			}

			//Otras caracteristicas del activo
			if (!Checks.esNulo(activoInfoComercial.getEstadoConservacionEdificio())) {
				informeComercial.setEstadoConservacionEdiCod(activoInfoComercial.getEstadoConservacionEdificio().getCodigo());
				informeComercial.setEstadoConservacionEdiDesc(activoInfoComercial.getEstadoConservacionEdificio().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getNumPlantasEdificio())) 
				informeComercial.setPlantasEdificio(activoInfoComercial.getNumPlantasEdificio().intValue());
			if (!Checks.esNulo(activoInfoComercial.getTipoPuerta())) {
				informeComercial.setPuertaAccesoCod(activoInfoComercial.getTipoPuerta().getCodigo());
				informeComercial.setPuertaAccesoDesc(activoInfoComercial.getTipoPuerta().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getEstadoPuertasInteriores())) {
				informeComercial.setEstadoPuertasIntCod(activoInfoComercial.getEstadoPuertasInteriores().getCodigo());
				informeComercial.setEstadoPuertasIntDesc(activoInfoComercial.getEstadoPuertasInteriores().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getEstadoPersianas())) {
				informeComercial.setEstadoPersianasCod(activoInfoComercial.getEstadoPersianas().getCodigo());
				informeComercial.setEstadoPersianasDesc(activoInfoComercial.getEstadoPersianas().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getEstadoVentanas())) {
				informeComercial.setEstadoVentanasCod(activoInfoComercial.getEstadoVentanas().getCodigo());
				informeComercial.setEstadoVentanasDesc(activoInfoComercial.getEstadoVentanas().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getEstadoPintura())) {
				informeComercial.setEstadoPinturaCod(activoInfoComercial.getEstadoPintura().getCodigo());
				informeComercial.setEstadoPinturaDesc(activoInfoComercial.getEstadoPintura().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getEstadoSolados())) {
				informeComercial.setEstadoSoladosCod(activoInfoComercial.getEstadoSolados().getCodigo());
				informeComercial.setEstadoSoladosDesc(activoInfoComercial.getEstadoSolados().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getEstadoBanyos())) {
				informeComercial.setEstadoBanyosCod(activoInfoComercial.getEstadoBanyos().getCodigo());
				informeComercial.setEstadoBanyosDesc(activoInfoComercial.getEstadoBanyos().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getAdmiteMascotas())) {
				informeComercial.setAdmiteMascotaCod(activoInfoComercial.getAdmiteMascotas().getCodigo());
				informeComercial.setAdmiteMascotaDesc(activoInfoComercial.getAdmiteMascotas().getDescripcion());
			}

			if (!Checks.esNulo(activoInfoComercial.getLicenciaApertura())) {
				informeComercial.setLicenciaAperturaCod(activoInfoComercial.getLicenciaApertura().getCodigo());
				informeComercial.setLicenciaAperturaDesc(activoInfoComercial.getLicenciaApertura().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getSalidaHumos())) {
				informeComercial.setSalidaHumoCod(activoInfoComercial.getSalidaHumos().getCodigo());
				informeComercial.setSalidaHumoDesc(activoInfoComercial.getSalidaHumos().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getAptoUsoBruto())) {
				informeComercial.setAptoUsoCod(activoInfoComercial.getAptoUsoBruto().getCodigo());
				informeComercial.setAptoUsoDesc(activoInfoComercial.getAptoUsoBruto().getDescripcion());
			}
			if(!Checks.esNulo(activoInfoComercial.getAccesibilidad())) {
				informeComercial.setAccesibilidadCod(activoInfoComercial.getAccesibilidad().getCodigo());
				informeComercial.setAccesibilidadDesc(activoInfoComercial.getAccesibilidad().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getEdificabilidad())) 
				informeComercial.setEdificabilidadTecho(activoInfoComercial.getEdificabilidad().doubleValue());
			if (!Checks.esNulo(activoInfoComercial.getSuperficieParcela())) 
				informeComercial.setSuperficieSuelo(activoInfoComercial.getSuperficieParcela().doubleValue());
			if (!Checks.esNulo(activoInfoComercial.getUrbanizacionEjecutado())) 
				informeComercial.setPorcUrbEjecutada(activoInfoComercial.getUrbanizacionEjecutado().doubleValue());
			if (!Checks.esNulo(activoInfoComercial.getClasificacion())) {
				informeComercial.setClasificacionCod(activoInfoComercial.getClasificacion().getCodigo());
				informeComercial.setClasificacionDesc(activoInfoComercial.getClasificacion().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getUsoActivo())) {
				informeComercial.setUsoCod(activoInfoComercial.getUsoActivo().getCodigo());
				informeComercial.setUsoDesc(activoInfoComercial.getUsoActivo().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getMetrosFachada())) 
				informeComercial.setMetrosFachada(activoInfoComercial.getMetrosFachada().doubleValue());
			if (!Checks.esNulo(activoInfoComercial.getAlmacen())) {
				informeComercial.setAlmacenCod(activoInfoComercial.getAlmacen().getCodigo());
				informeComercial.setAlmacenDesc(activoInfoComercial.getAlmacen().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getSuperficieAlmacen())) 
				informeComercial.setMetrosAlmacen(activoInfoComercial.getSuperficieAlmacen().doubleValue());
			if (!Checks.esNulo(activoInfoComercial.getVentaExposicion())) {
				informeComercial.setSupVentaExpoCod(activoInfoComercial.getVentaExposicion().getCodigo());
				informeComercial.setSupVentaExpoDesc(activoInfoComercial.getVentaExposicion().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getSuperficieVentaExposicion())) 
				informeComercial.setMetrosSupVentaExpo(activoInfoComercial.getSuperficieVentaExposicion().doubleValue());
			if (!Checks.esNulo(activoInfoComercial.getEntreplanta())) {
				informeComercial.setEntreplantaCod(activoInfoComercial.getEntreplanta().getCodigo());
				informeComercial.setEntreplantaDesc(activoInfoComercial.getEntreplanta().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getAlturaLibre())) 
				informeComercial.setAlturaLibre(activoInfoComercial.getAlturaLibre().doubleValue());
			if (!Checks.esNulo(activoInfoComercial.getEdificacionEjecutada())) 
				informeComercial.setPorcEdiEjecutada(activoInfoComercial.getEdificacionEjecutada().doubleValue());
			

			//Equipamientos
			if (!Checks.esNulo(activoInfoComercial.getZonasVerdes())) {
				informeComercial.setZonaVerdeCod(activoInfoComercial.getZonasVerdes().getCodigo());
				informeComercial.setZonaVerdeDesc(activoInfoComercial.getZonasVerdes().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getJardin())) {
				informeComercial.setJardinCod(activoInfoComercial.getJardin().getCodigo());
				informeComercial.setJardinDesc(activoInfoComercial.getJardin().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getInstalacionesDeportivas())) {
				informeComercial.setZonaDeportivaCod(activoInfoComercial.getInstalacionesDeportivas().getCodigo());
				informeComercial.setZonaDeportivaDesc(activoInfoComercial.getInstalacionesDeportivas().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getGimnasio())) {
				informeComercial.setGimnasioCod(activoInfoComercial.getGimnasio().getCodigo());
				informeComercial.setGimnasioDesc(activoInfoComercial.getGimnasio().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getPiscina())) {
				informeComercial.setPiscinaCod(activoInfoComercial.getPiscina().getCodigo());
				informeComercial.setPiscinaDesc(activoInfoComercial.getPiscina().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getConserje())) {
				informeComercial.setConserjeCod(activoInfoComercial.getConserje().getCodigo());
				informeComercial.setConserjeDesc(activoInfoComercial.getConserje().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getAccesoMinusvalidos())) {
				informeComercial.setAccesoMovReducidaCod(activoInfoComercial.getAccesoMinusvalidos().getCodigo());
				informeComercial.setAccesoMovReducidaDesc(activoInfoComercial.getAccesoMinusvalidos().getDescripcion());
			}

			//Comunicaciones y servicios
			if (!Checks.esNulo(activoInfoComercial.getUbicacionActivo())) {
				informeComercial.setUbicacionCod(activoInfoComercial.getUbicacionActivo().getCodigo());
				informeComercial.setUbicacionDesc(activoInfoComercial.getUbicacionActivo().getDescripcion());
			}
			if (!Checks.esNulo(activoInfoComercial.getValoracionUbicacion())) {
				informeComercial.setValUbicacionCod(activoInfoComercial.getValoracionUbicacion().getCodigo());
				informeComercial.setValUbicacionDesc(activoInfoComercial.getValoracionUbicacion().getDescripcion());
			}

			//Otra info de interes
			//informeComercial.setModificadoInforme(activoInfoComercial);
			//informeComercial.setCompletadoInforme(activoInfoComercial);
			//informeComercial.setFechaModificadoInforme(activoInfoComercial);
			//informeComercial.setFechaCompletadoInforme(activoInfoComercial);
			//informeComercial.setFechaRecepcionInforme(activoInfoComercial);
		}		

		// HREOS-2761: Buscamos los campos que pueden ser propagados para esta pestaña
		if(!Checks.esNulo(activo) && !activoDao.isActivoMatriz(activo.getId())) {
			// Buscamos los campos que pueden ser propagados para esta pestaña
			informeComercial.setCamposPropagables(TabActivoService.TAB_INFORMACION_COMERCIAL);
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

		DtoActivoInformacionComercial activoInformeDto = (DtoActivoInformacionComercial) webDto;
		ActivoInfoComercial actInfoComercial = null;
		Filter filtro = null;
		if (Checks.esNulo(activo.getInfoComercial())){
			actInfoComercial = new ActivoInfoComercial();
			actInfoComercial.setActivo(activo);					
			activo.setInfoComercial(actInfoComercial);
		}else {
			actInfoComercial = activo.getInfoComercial();
		}
		
		if (!Checks.esNulo(actInfoComercial)) {


			DtoActivoInformacionComercial dto = (DtoActivoInformacionComercial) webDto;
			
			if (Checks.esNulo(activo.getInfoComercial())) {
				activo.setInfoComercial(new ActivoInfoComercial());
				activo.getInfoComercial().setActivo(activo);
			}
			
			if (!Checks.esNulo(activoInformeDto.getDescripcionComercial())) {
				actInfoComercial.setDescripcionComercial(activoInformeDto.getDescripcionComercial());
			}
			if (!Checks.esNulo(activoInformeDto.getFechaVisita())) {
				actInfoComercial.setFechaUltimaVisita(activoInformeDto.getFechaVisita());
			}
			if (!Checks.esNulo(activoInformeDto.getEnvioLlavesApi())) {
				actInfoComercial.setEnvioLlavesApi(activoInformeDto.getEnvioLlavesApi());
			}
										
			//Direccion
			if (!Checks.esNulo(activoInformeDto.getProvinciaCodigo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getProvinciaCodigo());
				actInfoComercial.setProvincia(genericDao.get(DDProvincia.class, filtro));
			}

			if (!Checks.esNulo(activoInformeDto.getMunicipioCodigo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getMunicipioCodigo());
				actInfoComercial.setLocalidad(genericDao.get(Localidad.class, filtro));
			}

			if (!Checks.esNulo(activoInformeDto.getTipoActivoCodigo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getTipoActivoCodigo());
				actInfoComercial.setTipoActivo(genericDao.get(DDTipoActivo.class, filtro));
			} else if (!Checks.esNulo(activo.getTipoActivo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activo.getTipoActivo().getCodigo());
				actInfoComercial.setTipoActivo(genericDao.get(DDTipoActivo.class, filtro));
			}

			if (!Checks.esNulo(activoInformeDto.getSubtipoActivoCodigo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getSubtipoActivoCodigo());
				actInfoComercial.setSubtipoActivo(genericDao.get(DDSubtipoActivo.class, filtro));
			} else if (!Checks.esNulo(activo.getSubtipoActivo())){
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activo.getSubtipoActivo().getCodigo());
				actInfoComercial.setSubtipoActivo(genericDao.get(DDSubtipoActivo.class, filtro));
			}

			if (!Checks.esNulo(activoInformeDto.getTipoViaCodigo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getTipoViaCodigo());
				actInfoComercial.setTipoVia(genericDao.get(DDTipoVia.class, filtro));
			}
			
			if (!Checks.esNulo(activoInformeDto.getNombreVia()))
				actInfoComercial.setNombreVia(activoInformeDto.getNombreVia());
			if (!Checks.esNulo(activoInformeDto.getEscalera()))
				actInfoComercial.setEscalera(activoInformeDto.getEscalera());
			if (!Checks.esNulo(activoInformeDto.getNumeroDomicilio()))
				actInfoComercial.setPlanta(activoInformeDto.getNumeroDomicilio());
			if (!Checks.esNulo(activoInformeDto.getPuerta()))
				actInfoComercial.setPuerta(activoInformeDto.getPuerta());
			if (!Checks.esNulo(activoInformeDto.getCodPostal())) 
				actInfoComercial.setCodigoPostal(activoInformeDto.getCodPostal());

			if (!Checks.esNulo(activoInformeDto.getNombreVia())) {
				actInfoComercial.setNombreVia(activoInformeDto.getNombreVia());
			}

			if (!Checks.esNulo(activoInformeDto.getPiso())) {
				actInfoComercial.setPlanta(activoInformeDto.getPiso());
			}

			if (!Checks.esNulo(activoInformeDto.getLatitud())) {
				BigDecimal bigDecimalLatitud = BigDecimal.valueOf(Double.valueOf(activoInformeDto.getLatitud()));
				actInfoComercial.setLatitud(bigDecimalLatitud);
			}
			if (!Checks.esNulo(activoInformeDto.getLongitud())) {
				BigDecimal bigDecimalLongitud = BigDecimal.valueOf(Double.valueOf(activoInformeDto.getLongitud()));
				actInfoComercial.setLongitud(bigDecimalLongitud);
			}
			
			/*if (!Checks.esNulo(activoInformeDto.getInferiorMunicipioCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getInferiorMunicipioCodigo());
				DDUnidadPoblacional unidadPoblacional = (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class, filtro);
				beanUtilNotNull.copyProperty(actInfoComercial, "unidadPoblacional", unidadPoblacional);
			}

			if (!Checks.esNulo(activoInformeDto.getUbicacionActivoCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getUbicacionActivoCodigo());
				DDUbicacionActivo ubicacionActivo = (DDUbicacionActivo) genericDao.get(DDUbicacionActivo.class, filtro);
				beanUtilNotNull.copyProperty(actInfoComercial, "ubicacionActivo", ubicacionActivo);
			}*/
			
			//Informe Mediador
			/*if (!Checks.esNulo(activoInformeDto.getPosibleInforme())){
				beanUtilNotNull.copyProperty(actInfoComercial, "posibleInforme", activoInformeDto.getPosibleInforme());
					if (activoInformeDto.getPosibleInforme() == 1){
						beanUtilNotNull.copyProperty(actInfoComercial, "motivoNoPosibleInforme", " ");
					} else {
						if (!Checks.esNulo(activoInformeDto.getMotivoNoPosibleInforme())){
							beanUtilNotNull.copyProperty(actInfoComercial, "motivoNoPosibleInforme", activoInformeDto.getMotivoNoPosibleInforme());
						}
					}
			}*/
			
			//Informacion general
			if (!Checks.esNulo(activoInformeDto.getRegimenInmuebleCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getRegimenInmuebleCod());
				actInfoComercial.setRegimenProteccion(genericDao.get(DDTipoVpo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getEstadoOcupacionalCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoOcupacionalCod());
				actInfoComercial.setEstadoOcupacional(genericDao.get(DDEstadoOcupacional.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getAnyoConstruccion())) 
				actInfoComercial.setAnyoConstruccion(activoInformeDto.getAnyoConstruccion());
			
			//Caracteristicas del activo
			if (!Checks.esNulo(activoInformeDto.getDormitorios())) 
				actInfoComercial.setNumDormitorios(activoInformeDto.getDormitorios().longValue());
			if (!Checks.esNulo(activoInformeDto.getBanyos())) 
				actInfoComercial.setNumBanyos(activoInformeDto.getBanyos().longValue());
			if (!Checks.esNulo(activoInformeDto.getAseos()))
				actInfoComercial.setNumAseos(activoInformeDto.getAseos().longValue());
			if (!Checks.esNulo(activoInformeDto.getAscensorCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getAscensorCod());
				actInfoComercial.setAscensor(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getPlazasGaraje())) 
				actInfoComercial.setNumGaraje(activoInformeDto.getPlazasGaraje().longValue());
			if (!Checks.esNulo(activoInformeDto.getTerrazaCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getTerrazaCod());
				actInfoComercial.setTerraza(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getPatioCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getPatioCod());
				actInfoComercial.setPatio(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getRehabilitadoCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getRehabilitadoCod());
				actInfoComercial.setRehabilitado(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getAnyoRehabilitacion())) {
				actInfoComercial.setAnyoRehabilitacion(activoInformeDto.getAnyoRehabilitacion());
			}
			if (!Checks.esNulo(activoInformeDto.getVisitableCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getVisitableCod());
				actInfoComercial.setVisitable(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getOcupadoCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getOcupadoCod());
				actInfoComercial.setOcupado(genericDao.get(DDSinSiNo.class, filtro));
			}

			if (!Checks.esNulo(activoInformeDto.getSalones())) {
				actInfoComercial.setNumSalones(activoInformeDto.getSalones().longValue());
			}
			if (!Checks.esNulo(activoInformeDto.getEstancias())) {
				actInfoComercial.setNumEstancias(activoInformeDto.getEstancias().longValue());
			}
			if (!Checks.esNulo(activoInformeDto.getPlantas())) {
				actInfoComercial.setNumPlantas(activoInformeDto.getPlantas().longValue());
			}

			if (!Checks.esNulo(activoInformeDto.getSuperficieTerraza())) {
				actInfoComercial.setSuperficieTerraza(activoInformeDto.getSuperficieTerraza().floatValue());
			}

			if (!Checks.esNulo(activoInformeDto.getSuperficiePatio())) {
				actInfoComercial.setSuperficiePatio(activoInformeDto.getSuperficiePatio().floatValue());
			}

			if (!Checks.esNulo(activoInformeDto.getEstadoConservacionCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoConservacionCod());
				actInfoComercial.setEstadoConservacion(genericDao.get(DDEstadoConservacion.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getAnejoGarajeCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getAnejoGarajeCod());
				actInfoComercial.setAnejoGaraje(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getAnejoTrasteroCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getAnejoTrasteroCod());
				actInfoComercial.setAnejoTrastero(genericDao.get(DDSinSiNo.class, filtro));
			}
			
			//Caracteristicas ppales del activo
			if (!Checks.esNulo(activoInformeDto.getOrientacion())) {
				actInfoComercial.setOrientacion(activoInformeDto.getOrientacion());
			}
			if (!Checks.esNulo(activoInformeDto.getExtIntCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getExtIntCod());
				actInfoComercial.setExteriorInterior(genericDao.get(DDExteriorInterior.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getCocRatingCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getCocRatingCod());
				actInfoComercial.setRatingCocina(genericDao.get(DDRatingCocina.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getCocAmuebladaCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getCocAmuebladaCod());
				actInfoComercial.setCocinaAmueblada(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getArmEmpotradosCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getArmEmpotradosCod());
				actInfoComercial.setArmariosEmpotrados(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getCalefaccion())) {
				actInfoComercial.setCalefaccion(activoInformeDto.getCalefaccion());
			}
			if (!Checks.esNulo(activoInformeDto.getTipoCalefaccionCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getTipoCalefaccionCod());
				actInfoComercial.setTipoCalefaccion(genericDao.get(DDTipoCalefaccion.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getAireAcondCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getAireAcondCod());
				actInfoComercial.setAireAcondicionado(genericDao.get(DDTipoClimatizacion.class, filtro));
			}
				
			//Otras caracteristicas del activo (!vivienda)
			if (!Checks.esNulo(activoInformeDto.getLicenciaAperturaCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getLicenciaAperturaCod());
				actInfoComercial.setLicenciaApertura(genericDao.get(DDSinSiNo.class, filtro));
			}
				
			if(!Checks.esNulo(activoInformeDto.getAccesibilidadCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getAccesibilidadCod());
				actInfoComercial.setAccesibilidad(genericDao.get(DDActivoAccesibilidad.class, filtro));
			}
			
			//Otras caracteristicas del activo
			if (!Checks.esNulo(activoInformeDto.getEstadoConservacionEdiCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoConservacionEdiCod());
				actInfoComercial.setEstadoConservacionEdificio(genericDao.get(DDEstadoConservacionEdificio.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getPlantasEdificio())) {
				actInfoComercial.setNumPlantasEdificio(activoInformeDto.getPlantasEdificio().longValue());
			}
			if (!Checks.esNulo(activoInformeDto.getPuertaAccesoCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getPuertaAccesoCod());
				actInfoComercial.setTipoPuerta(genericDao.get(DDTipoPuerta.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getEstadoPuertasIntCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoPuertasIntCod());
				actInfoComercial.setEstadoPuertasInteriores(genericDao.get(DDEstadoMobiliario.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getEstadoPersianasCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoPersianasCod());
				actInfoComercial.setEstadoPersianas(genericDao.get(DDEstadoMobiliario.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getEstadoVentanasCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoVentanasCod());
				actInfoComercial.setEstadoVentanas(genericDao.get(DDEstadoMobiliario.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getEstadoPinturaCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoPinturaCod());
				actInfoComercial.setEstadoPintura(genericDao.get(DDEstadoMobiliario.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getEstadoSoladosCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoSoladosCod());
				actInfoComercial.setEstadoSolados(genericDao.get(DDEstadoMobiliario.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getEstadoBanyosCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoBanyosCod());
				actInfoComercial.setEstadoBanyos(genericDao.get(DDEstadoMobiliario.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getAdmiteMascotaCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getAdmiteMascotaCod());
				actInfoComercial.setAdmiteMascotas(genericDao.get(DDAdmision.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getSalidaHumoCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getSalidaHumoCod());
				actInfoComercial.setSalidaHumos(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getAptoUsoCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getAptoUsoCod());
				actInfoComercial.setAptoUsoBruto(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getEdificabilidadTecho())) {
				actInfoComercial.setEdificabilidad(activoInformeDto.getEdificabilidadTecho().floatValue());
			}
			if (!Checks.esNulo(activoInformeDto.getSuperficieSuelo())) {
				actInfoComercial.setSuperficieParcela(activoInformeDto.getSuperficieSuelo().floatValue());
			}
			if (!Checks.esNulo(activoInformeDto.getPorcUrbEjecutada())) {
				actInfoComercial.setUrbanizacionEjecutado(activoInformeDto.getPorcUrbEjecutada().floatValue());
			}
			if (!Checks.esNulo(activoInformeDto.getClasificacionCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getClasificacionCod());
				actInfoComercial.setClasificacion(genericDao.get(DDClasificacion.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getUsoCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getUsoCod());
				actInfoComercial.setUsoActivo(genericDao.get(DDUsoActivo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getMetrosFachada())) {
				actInfoComercial.setMetrosFachada(activoInformeDto.getMetrosFachada().floatValue());
			}
			if (!Checks.esNulo(activoInformeDto.getAlmacenCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getAlmacenCod());
				actInfoComercial.setAlmacen(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getMetrosAlmacen())) {
				actInfoComercial.setSuperficieAlmacen(activoInformeDto.getMetrosAlmacen().floatValue());
			}
			if (!Checks.esNulo(activoInformeDto.getSupVentaExpoCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getSupVentaExpoCod());
				actInfoComercial.setVentaExposicion(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getMetrosSupVentaExpo())) {
				actInfoComercial.setSuperficieVentaExposicion(activoInformeDto.getMetrosSupVentaExpo().floatValue());
			}
			if (!Checks.esNulo(activoInformeDto.getEntreplantaCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEntreplantaCod());
				actInfoComercial.setEntreplanta(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getAlturaLibre())) {
				actInfoComercial.setAlturaLibre(activoInformeDto.getAlturaLibre().floatValue());
			}
			if (!Checks.esNulo(activoInformeDto.getPorcEdiEjecutada())) {
				actInfoComercial.setEdificacionEjecutada(activoInformeDto.getPorcEdiEjecutada().floatValue());
			}
			
			//Equipamientos
			if (!Checks.esNulo(activoInformeDto.getZonaVerdeCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getZonaVerdeCod());
				actInfoComercial.setZonasVerdes(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getJardinCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getJardinCod());
				actInfoComercial.setJardin(genericDao.get(DDDisponibilidad.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getZonaDeportivaCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getZonaDeportivaCod());
				actInfoComercial.setInstalacionesDeportivas(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getGimnasioCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getGimnasioCod());
				actInfoComercial.setGimnasio(genericDao.get(DDDisponibilidad.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getPiscinaCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getPiscinaCod());
				actInfoComercial.setPiscina(genericDao.get(DDDisponibilidad.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getConserjeCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getConserjeCod());
				actInfoComercial.setConserje(genericDao.get(DDSinSiNo.class, filtro));
			}
			if (!Checks.esNulo(activoInformeDto.getAccesoMovReducidaCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getAccesoMovReducidaCod());
				actInfoComercial.setAccesoMinusvalidos(genericDao.get(DDSinSiNo.class, filtro));
			}
			
			//Comunicaciones y servicios
			if(!Checks.esNulo(activoInformeDto.getUbicacionCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getUbicacionCod());
				actInfoComercial.setUbicacionActivo(genericDao.get(DDUbicacionActivo.class, filtro));
			}
			if(!Checks.esNulo(activoInformeDto.getValUbicacionCod())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getValUbicacionCod());
				actInfoComercial.setValoracionUbicacion(genericDao.get(DDValoracionUbicacion.class, filtro));
			}
			/*if(!Checks.esNulo(actInfoComercial.getPosibleInforme())) {
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
			
			}*/
			genericDao.save(ActivoInfoComercial.class, actInfoComercial);
			activoApi.saveOrUpdate(activo);
			
		}

		return activo;
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