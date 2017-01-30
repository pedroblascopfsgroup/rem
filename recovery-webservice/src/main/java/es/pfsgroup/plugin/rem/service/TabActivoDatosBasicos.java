package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoLocalizacion;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpIncorrienteBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpRiesgoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProductoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Component
public class TabActivoDatosBasicos implements TabActivoService {
    

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private UpdaterStateApi updaterState;

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_DATOS_BASICOS};
	}
	
	
	public DtoActivoFichaCabecera getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoFichaCabecera activoDto = new DtoActivoFichaCabecera();

		BeanUtils.copyProperties(activoDto, activo);
		
		if (activo.getLocalizacion() != null) {
			BeanUtils.copyProperties(activoDto, activo.getLocalizacion().getLocalizacionBien());
			BeanUtils.copyProperties(activoDto, activo.getLocalizacion());
			
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null) {
				BeanUtils.copyProperty(activoDto, "tipoViaCodigo", activo.getLocalizacion().getLocalizacionBien().getTipoVia().getCodigo());
			}
			
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null) {
				BeanUtils.copyProperty(activoDto, "tipoViaDescripcion", activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion());
			}
			
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getPais() != null) {
				BeanUtils.copyProperty(activoDto, "paisCodigo", activo.getLocalizacion().getLocalizacionBien().getPais().getCodigo());
			}
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null) {
				BeanUtils.copyProperty(activoDto, "municipioCodigo", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getCodigo());
				BeanUtils.copyProperty(activoDto, "municipioDescripcion", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion());
			}
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional() != null) {
				BeanUtils.copyProperty(activoDto, "inferiorMunicipioCodigo", activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional().getCodigo());
				BeanUtils.copyProperty(activoDto, "inferiorMunicipioDescripcion", activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional().getDescripcion());
			}
			if (activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null
					&& activo.getLocalizacion().getLocalizacionBien().getProvincia() != null) {
				BeanUtils.copyProperty(activoDto, "provinciaCodigo", activo.getLocalizacion().getLocalizacionBien().getProvincia().getCodigo());
				BeanUtils.copyProperty(activoDto, "provinciaDescripcion", activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion());

			}
		}
		
		if (activo.getCartera() != null) {
			BeanUtils.copyProperty(activoDto, "entidadPropietariaCodigo", activo.getCartera().getCodigo());
			BeanUtils.copyProperty(activoDto, "entidadPropietariaDescripcion", activo.getCartera().getDescripcion());
		}
		if(!Checks.esNulo(activo.getSubcartera())) {
			BeanUtils.copyProperty(activoDto, "subcarteraCodigo", activo.getSubcartera().getCodigo());
			BeanUtils.copyProperty(activoDto, "subcarteraDescripcion", activo.getSubcartera().getDescripcion());
		}
		if (activo.getRating() != null ) {
			BeanUtils.copyProperty(activoDto, "rating", activo.getRating().getCodigo());
		}
		
		BeanUtils.copyProperty(activoDto, "propietario", activo.getFullNamePropietario());	
		
		if(activo.getTipoActivo() != null ) {					
			BeanUtils.copyProperty(activoDto, "tipoActivoCodigo", activo.getTipoActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoActivoDescripcion", activo.getTipoActivo().getDescripcion());
			
			if(!Checks.esNulo(activo.getInfoComercial())) {
				if(!Checks.esNulo(activo.getInfoComercial().getTipoActivo())) {
					// Comprobar si el tipo de activo es el mismo tanto en el activo como en el informe comercial.
					BeanUtils.copyProperty(activoDto, "tipoActivoAdmisionMediadorCorresponde", activo.getTipoActivo().getCodigo().equals(activo.getInfoComercial().getTipoActivo().getCodigo()));
				}
			}
		}
		 
		if (activo.getSubtipoActivo() != null ) {
			BeanUtils.copyProperty(activoDto, "subtipoActivoCodigo", activo.getSubtipoActivo().getCodigo());	
			BeanUtils.copyProperty(activoDto, "subtipoActivoDescripcion", activo.getSubtipoActivo().getDescripcion());	
		}
		
		if (activo.getTipoTitulo() != null) {
			BeanUtils.copyProperty(activoDto, "tipoTitulo", activo.getTipoTitulo().getDescripcion());
			BeanUtils.copyProperty(activoDto, "tipoTituloCodigo", activo.getTipoTitulo().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoTituloDescripcion", activo.getTipoTitulo().getDescripcion());
		}
		
		if (activo.getSubtipoTitulo() != null) {
			BeanUtils.copyProperty(activoDto, "subtipoTitulo", activo.getSubtipoTitulo().getDescripcion());
			BeanUtils.copyProperty(activoDto, "subtipoTituloCodigo", activo.getSubtipoTitulo().getCodigo());
			BeanUtils.copyProperty(activoDto, "subtipoTituloDescripcion", activo.getSubtipoTitulo().getDescripcion());
		}
		
		if (activo.getCartera() != null) {
			BeanUtils.copyProperty(activoDto, "entidadPropietariaCodigo", activo.getCartera().getCodigo());
			BeanUtils.copyProperty(activoDto, "entidadPropietariaDescripcion", activo.getCartera().getDescripcion());
		}
		
		if (activo.getBien().getLocalizaciones() != null && activo.getBien().getLocalizaciones().get(0).getLocalidad() != null) {
			BeanUtils.copyProperty(activoDto, "municipioDescripcion", activo.getBien().getLocalizaciones().get(0).getLocalidad().getDescripcion());
		}
		
		if (activo.getEstadoActivo() != null) {
			BeanUtils.copyProperty(activoDto, "estadoActivoCodigo", activo.getEstadoActivo().getCodigo());
		}
		
		if (activo.getTipoUsoDestino() != null) {
			BeanUtils.copyProperty(activoDto, "tipoUsoDestinoCodigo", activo.getTipoUsoDestino().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoUsoDestinoDescripcion", activo.getTipoUsoDestino().getDescripcion());
		}
		
		/*if (activo.getComunidadPropietarios() != null) {
			BeanUtils.copyProperties(activoDto, activo.getComunidadPropietarios());
			BeanUtils.copyProperty(activoDto, "direccionComunidad", activo.getComunidadPropietarios().getDireccion());
		}*/
		
		if (activo.getInfoComercial() != null && activo.getInfoComercial().getTipoInfoComercial() != null) {
			BeanUtils.copyProperty(activoDto, "tipoInfoComercialCodigo", activo.getInfoComercial().getTipoInfoComercial().getCodigo());
		}
		
		if(activo.getEstadoPublicacion() != null){
			BeanUtils.copyProperty(activoDto, "estadoPublicacionDescripcion", activo.getEstadoPublicacion().getDescripcion());
			BeanUtils.copyProperty(activoDto, "estadoPublicacionCodigo", activo.getEstadoPublicacion().getCodigo());
		}
		
		if(activo.getTipoComercializar() != null){
			BeanUtils.copyProperty(activoDto, "tipoComercializarCodigo", activo.getTipoComercializar().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoComercializarDescripcion", activo.getTipoComercializar().getDescripcion());
		}
		//Hace referencia a Destino Comercial (Si te lía el nombre, habla con Fernando)
		if(activo.getTipoComercializacion() != null){
			BeanUtils.copyProperty(activoDto, "tipoComercializacionCodigo", activo.getTipoComercializacion().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoComercializacionDescripcion", activo.getTipoComercializacion().getDescripcion());
		}
		
		if(activo.getTipoAlquiler() != null){
			BeanUtils.copyProperty(activoDto, "tipoAlquilerCodigo", activo.getTipoAlquiler().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoAlquilerDescripcion", activo.getTipoAlquiler().getDescripcion());
		}
		
		if(activo.getAgrupaciones().size() > 0){
			Boolean pertenceAgrupacionRestringida= false;
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja())) {
					if(!Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion()) && DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())){
						pertenceAgrupacionRestringida= true;
						break;
					}
				}
			}
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionRestringida", pertenceAgrupacionRestringida);
		}

		// Obtener estado de aceptación del informe comercial.
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Order order = new Order(OrderType.DESC, "id");
		List<ActivoEstadosInformeComercialHistorico> activoEstadoInfComercialHistoricoList = genericDao.getListOrdered(ActivoEstadosInformeComercialHistorico.class, order, filter);
		if(!Checks.estaVacio(activoEstadoInfComercialHistoricoList)) {
			ActivoEstadosInformeComercialHistorico historico = activoEstadoInfComercialHistoricoList.get(0);
				BeanUtils.copyProperty(activoDto, "informeComercialAceptado", historico.getEstadoInformeComercial().getCodigo().equals(DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_ACEPTACION) ? true : false);
		}

		//HREOS-843 Situacion Comercial del activo
		if(!Checks.esNulo(activo.getSituacionComercial())) {
			BeanUtils.copyProperty(activoDto, "situacionComercialDescripcion", activo.getSituacionComercial().getDescripcion());
		}

		// Perimetros ------------------		
		// Datos de perimetro del activo al Dto de datos basicos
		// - Puede no existir registro de perimetros en la tabla. Esto no producira errores de carga/guardado
		// - En caso de no haber registro relacionado con el activo, no se habilitaran validaciones/bloqueos 
		//   relacionados con el perimetro.
		// - Aunque no haya registro de perimetros, en estos activos aparecerán todos los checks activos de la pantalla
		//   de datos basicos (para indicar que se incluyen todos los modulos del activo y no hay bloqueos)
		PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
		BeanUtils.copyProperties(activoDto, perimetroActivo);
		
		// Si no esta en el perimetro, el activo se considera SOLO CONSULTA
		BeanUtils.copyProperty(activoDto, "incluidoEnPerimetro", perimetroActivo.getIncluidoEnPerimetro() == 1);
		
		if(!Checks.esNulo(activo.getAuditoria()) && !Checks.esNulo(activo.getAuditoria().getFechaCrear())) {
			BeanUtils.copyProperty(activoDto, "fechaAltaActivoRem", activo.getAuditoria().getFechaCrear());
		}
		
		if(!Checks.esNulo(perimetroActivo) && !Checks.esNulo(perimetroActivo.getMotivoAplicaComercializar())) {
			BeanUtils.copyProperty(activoDto, "motivoAplicaComercializarCodigo", perimetroActivo.getMotivoAplicaComercializar().getCodigo());
			BeanUtils.copyProperty(activoDto, "motivoAplicaComercializarDescripcion", perimetroActivo.getMotivoAplicaComercializar().getDescripcion());
		}
		
		if(!Checks.esNulo(perimetroActivo) && !Checks.esNulo(perimetroActivo.getMotivoNoAplicaComercializar())) {
			BeanUtils.copyProperty(activoDto, "motivoNoAplicaComercializar", perimetroActivo.getMotivoNoAplicaComercializar());
		}
		
		// Si no exite perimetro en BBDD, se crea una nueva instancia PerimetroActivo, con todas las condiciones marcadas
		// y por tanto, por defecto se marcan los checkbox.
//		if(Checks.esNulo(perimetroActivo.getActivo())) {
		BeanUtils.copyProperty(activoDto,"aplicaTramiteAdmision", new Integer(1).equals( perimetroActivo.getAplicaTramiteAdmision())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaGestion", new Integer(1).equals( perimetroActivo.getAplicaGestion())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaAsignarMediador", new Integer(1).equals(perimetroActivo.getAplicaAsignarMediador())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaComercializar", new Integer(1).equals(perimetroActivo.getAplicaComercializar())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaFormalizar", new Integer(1).equals(perimetroActivo.getAplicaFormalizar())? true: false);
//		}
		// ----------
		
		
		// Datos de activo bancario -----------------
		// Datos de activo bancario del activo al Dto de datos basicos
		// - Puede no existir registro de activo bancario en la tabla. Esto no producira errores de carga/guardado
		ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(activo.getId());
		
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getClaseActivo())) {
			BeanUtils.copyProperty(activoDto, "claseActivoCodigo", activoBancario.getClaseActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "claseActivoDescripcion", activoBancario.getClaseActivo().getDescripcion());
		}
		
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getSubtipoClaseActivo())) {
			BeanUtils.copyProperty(activoDto, "subtipoClaseActivoCodigo", activoBancario.getSubtipoClaseActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "subtipoClaseActivoDescripcion", activoBancario.getSubtipoClaseActivo().getDescripcion());
		}
		
		/*if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getTipoProducto())) {
			BeanUtils.copyProperty(activoDto, "tipoProductoCodigo", activoBancario.getTipoProducto().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoProductoDescripcion", activoBancario.getTipoProducto().getDescripcion());
		}*/
		//Como no envian el diccionario de tipoProducto, lo hemos sustituido por texto libre
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getProductoDescripcion())) {
			BeanUtils.copyProperty(activoDto, "productoDescripcion", activoBancario.getProductoDescripcion());
		}
		
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getEstadoExpRiesgo())) {
			BeanUtils.copyProperty(activoDto, "estadoExpRiesgoCodigo", activoBancario.getEstadoExpRiesgo().getCodigo());
			BeanUtils.copyProperty(activoDto, "estadoExpRiesgoDescripcion", activoBancario.getEstadoExpRiesgo().getDescripcion());
		}
		
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getEstadoExpIncorriente())) {
			BeanUtils.copyProperty(activoDto, "estadoExpIncorrienteCodigo", activoBancario.getEstadoExpIncorriente().getCodigo());
			
		}
		// ------------
		
		//Activo integrado en agrupación asisitida
		BeanUtils.copyProperty(activoDto, "integradoEnAgrupacionAsistida",activoApi.isIntegradoAgrupacionAsistida(activo));
		
		//Tipo de activo segun el Mediador
		if(!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getTipoActivo())) {
			BeanUtils.copyProperty(activoDto, "tipoActivoMediadorCodigo", activo.getInfoComercial().getTipoActivo().getCodigo());
		}

		
		return activoDto;	
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
		DtoActivoFichaCabecera dto = (DtoActivoFichaCabecera) webDto;
		
		try {
			beanUtilNotNull.copyProperties(activo, dto);
			
			if (Checks.esNulo(activo.getLocalizacion())) {
				activo.setLocalizacion(new ActivoLocalizacion());
				activo.getLocalizacion().setActivo(activo);
			}
			
			if (Checks.esNulo(activo.getLocalizacion().getLocalizacionBien())){
				NMBLocalizacionesBien localizacionesVacia = new NMBLocalizacionesBien();
				localizacionesVacia.setBien(activo.getBien());
				activo.getLocalizacion().setLocalizacionBien(localizacionesVacia);
				activo.getLocalizacion().setLocalizacionBien(genericDao.save(NMBLocalizacionesBien.class, activo.getLocalizacion().getLocalizacionBien()));
			}
			
			beanUtilNotNull.copyProperties(activo.getLocalizacion(), dto);
			beanUtilNotNull.copyProperties(activo.getLocalizacion().getLocalizacionBien(), dto);
			
			activo.setLocalizacion(genericDao.save(ActivoLocalizacion.class, activo.getLocalizacion()));

			/*if (Checks.esNulo(activo.getComunidadPropietarios())) {	
				activo.setComunidadPropietarios(new ActivoComunidadPropietarios());
			}*/
			
			/*beanUtilNotNull.copyProperties(activo.getComunidadPropietarios(), dto);
			beanUtilNotNull.copyProperty(activo.getComunidadPropietarios(), "direccion", dto.getDireccionComunidad());*/
			
			/*String cuentaUno = "";
			String cuentaDos = "";
			String cuentaTres = "";
			String cuentaCuatro = "";
			String cuentaCinco = "";
			
			if (!Checks.esNulo(dto.getNumCuentaUno()) || !Checks.esNulo(dto.getNumCuentaDos()) || !Checks.esNulo(dto.getNumCuentaTres()) || !Checks.esNulo(dto.getNumCuentaCuatro()) || !Checks.esNulo(dto.getNumCuentaCinco())) {
				
				String numCuentaTrim = "";
				if (!Checks.esNulo(activo.getComunidadPropietarios().getNumCuenta())) {
					numCuentaTrim = activo.getComunidadPropietarios().getNumCuenta().trim();
				}

				if (!Checks.esNulo(dto.getNumCuentaUno())) {
					cuentaUno = dto.getNumCuentaUno();
				} else if (!Checks.esNulo(activo.getComunidadPropietarios().getNumCuenta())) {
					cuentaUno = numCuentaTrim.substring(0, 4);
				}
				
				if (!Checks.esNulo(dto.getNumCuentaDos())) {
					cuentaDos = dto.getNumCuentaDos();
				} else if (!Checks.esNulo(activo.getComunidadPropietarios().getNumCuenta())) {
					cuentaDos = numCuentaTrim.substring(4, 8);
				}
				
				if (!Checks.esNulo(dto.getNumCuentaTres())) {
					cuentaTres = dto.getNumCuentaTres();
				} else if (!Checks.esNulo(activo.getComunidadPropietarios().getNumCuenta())) {
					cuentaTres = numCuentaTrim.substring(8, 12);
				}
				
				if (!Checks.esNulo(dto.getNumCuentaCuatro())) {
					cuentaCuatro = dto.getNumCuentaCuatro();
				} else if (!Checks.esNulo(activo.getComunidadPropietarios().getNumCuenta())) {
					cuentaCuatro = numCuentaTrim.substring(12, 14);
				}
				
				if (!Checks.esNulo(dto.getNumCuentaCinco())) {
					cuentaCinco = dto.getNumCuentaCinco();
				} else if (!Checks.esNulo(activo.getComunidadPropietarios().getNumCuenta())) {
					cuentaCinco = numCuentaTrim.substring(14);
				}
				
				beanUtilNotNull.copyProperty(activo.getComunidadPropietarios(), "numCuenta", cuentaUno + cuentaDos + cuentaTres + cuentaCuatro + cuentaCinco);
				
			}*/

			/*activo.setComunidadPropietarios(genericDao.save(ActivoComunidadPropietarios.class, activo.getComunidadPropietarios()));*/

			if (!Checks.esNulo(dto.getPaisCodigo())) {
				DDCicCodigoIsoCirbeBKP pais = (DDCicCodigoIsoCirbeBKP) diccionarioApi.dameValorDiccionarioByCod(DDCicCodigoIsoCirbeBKP.class,  dto.getPaisCodigo());
				activo.getLocalizacion().getLocalizacionBien().setPais(pais);
			}
			
			if (!Checks.esNulo(dto.getTipoViaCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoViaCodigo());
				DDTipoVia tipoViaNueva = (DDTipoVia) genericDao.get(DDTipoVia.class, filtro);
				activo.getLocalizacion().getLocalizacionBien().setTipoVia(tipoViaNueva);
			}
			
			if (!Checks.esNulo(dto.getProvinciaCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
				DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, filtro);
				activo.getLocalizacion().getLocalizacionBien().setProvincia(provincia);
			}
			
			if (!Checks.esNulo(dto.getMunicipioCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
				activo.getLocalizacion().getLocalizacionBien().setLocalidad(municipioNuevo);
			}
			
			if (!Checks.esNulo(dto.getInferiorMunicipioCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getInferiorMunicipioCodigo());
				DDUnidadPoblacional inferiorNuevo = (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class, filtro);
				activo.getLocalizacion().getLocalizacionBien().setUnidadPoblacional(inferiorNuevo);
			}
			
			activo.getLocalizacion().setLocalizacionBien(genericDao.save(NMBLocalizacionesBien.class, activo.getLocalizacion().getLocalizacionBien()));
			
			if (!Checks.esNulo(dto.getTipoActivoCodigo())) {
				DDTipoActivo tipoActivo = (DDTipoActivo) diccionarioApi.dameValorDiccionarioByCod(DDTipoActivo.class,  dto.getTipoActivoCodigo());
				activo.setTipoActivo(tipoActivo);
			}
			
			if (!Checks.esNulo(dto.getSubtipoActivoCodigo())) {
				DDSubtipoActivo subtipoActivo = (DDSubtipoActivo) diccionarioApi.dameValorDiccionarioByCod(DDSubtipoActivo.class,  dto.getSubtipoActivoCodigo());
				activo.setSubtipoActivo(subtipoActivo);
			}
			
			if (!Checks.esNulo(dto.getTipoTitulo())) {
				DDTipoTituloActivo tipoTitulo = (DDTipoTituloActivo) diccionarioApi.dameValorDiccionarioByCod(DDTipoTituloActivo.class,  dto.getTipoTitulo());
				activo.setTipoTitulo(tipoTitulo);
			}
			
			if (!Checks.esNulo(dto.getTipoUsoDestinoCodigo())) {
				DDTipoUsoDestino tipoUsoDestino = (DDTipoUsoDestino) diccionarioApi.dameValorDiccionarioByCod(DDTipoUsoDestino.class,  dto.getTipoUsoDestinoCodigo());
				activo.setTipoUsoDestino(tipoUsoDestino);
				//Actualizar el tipoComercialización del activo
				updaterState.updaterStateTipoComercializacion(activo);
			}
			
			if (!Checks.esNulo(dto.getEstadoActivoCodigo())) {
				DDEstadoActivo estadoActivo = (DDEstadoActivo) diccionarioApi.dameValorDiccionarioByCod(DDEstadoActivo.class,  dto.getEstadoActivoCodigo());
				activo.setEstadoActivo(estadoActivo);
			}
			
			// Se genera un registro en el histórico por la modificación de los datos en el apartado de 'Datos Admisión' de informe comercial.
			if(
				!Checks.esNulo(dto.getTipoActivoCodigo()) || !Checks.esNulo(dto.getSubtipoActivoCodigo()) ||
				!Checks.esNulo(dto.getTipoViaCodigo()) || !Checks.esNulo(dto.getNombreVia()) || 
				!Checks.esNulo(dto.getNumeroDomicilio()) || !Checks.esNulo(dto.getEscalera()) ||
				!Checks.esNulo(dto.getPiso()) || !Checks.esNulo(dto.getPuerta()) ||
				!Checks.esNulo(dto.getCodPostal()) || !Checks.esNulo(dto.getMunicipioCodigo()) ||
				!Checks.esNulo(dto.getProvinciaCodigo()) || !Checks.esNulo(dto.getLatitud()) ||
				!Checks.esNulo(dto.getLongitud()))
			{
				ActivoEstadosInformeComercialHistorico activoEstadoInfComercialHistorico = new ActivoEstadosInformeComercialHistorico();
				activoEstadoInfComercialHistorico.setActivo(activo);
				Filter filtroDDInfComercial = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_MODIFICACION);
				DDEstadoInformeComercial ddInfComercial = genericDao.get(DDEstadoInformeComercial.class, filtroDDInfComercial);
				activoEstadoInfComercialHistorico.setEstadoInformeComercial(ddInfComercial);
				activoEstadoInfComercialHistorico.setFecha(new Date());
				activoEstadoInfComercialHistorico.setMotivo(DtoEstadosInformeComercialHistorico.ESTADO_MOTIVO_MODIFICACION_MANUAL);
				genericDao.save(ActivoEstadosInformeComercialHistorico.class, activoEstadoInfComercialHistorico);
			}

			// Perimetro -------
			// Solo se guardan los datos si el usuario ha cambiado algun campo de perimetros
			// El control de cambios se realiza revisando los datos que transporta el dto
			// Solo se modifican/crean nuevos registros de perimetros si hay guardado de datos
			if(
				dto.getAplicaAsignarMediador() != null || dto.getAplicaComercializar() != null || dto.getAplicaFormalizar() != null || 
				dto.getAplicaGestion() != null  || dto.getAplicaTramiteAdmision() != null || dto.getMotivoAplicaComercializarCodigo() != null ||
				dto.getMotivoNoAplicaComercializar() != null || 
				dto.getIncluidoEnPerimetro() != null ||	dto.getFechaAltaActivoRem() != null || dto.getAplicaTramiteAdmision() != null || 
				dto.getFechaAplicaTramiteAdmision() != null || dto.getMotivoAplicaTramiteAdmision() != null ||	dto.getAplicaGestion() != null ||
				dto.getFechaAplicaGestion() != null || dto.getMotivoAplicaGestion() != null || dto.getAplicaAsignarMediador() != null ||
				dto.getFechaAplicaAsignarMediador() != null || dto.getMotivoAplicaAsignarMediador() != null || dto.getAplicaComercializar() != null || 
				dto.getFechaAplicaComercializar() != null || dto.getMotivoAplicaComercializarCodigo() != null || dto.getMotivoAplicaComercializarDescripcion() != null ||
				dto.getMotivoNoAplicaComercializar() != null || dto.getAplicaFormalizar() != null || dto.getFechaAplicaFormalizar() != null || dto.getMotivoAplicaFormalizar() != null)
				 
			{
				
				PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
				beanUtilNotNull.copyProperties(perimetroActivo, dto);
				
				//Si no existe perimetro, se creará un registro nuevo, con las opciones por defecto
				if(Checks.esNulo(perimetroActivo.getActivo())) {
					perimetroActivo.setActivo(activo);
					perimetroActivo.setIncluidoEnPerimetro(1);
					perimetroActivo.setAplicaAsignarMediador(1);
					perimetroActivo.setAplicaComercializar(1);
					perimetroActivo.setAplicaFormalizar(1);
					perimetroActivo.setAplicaGestion(1);
					perimetroActivo.setAplicaTramiteAdmision(1);
				}
				
				// Conversion manual. En el dto son booleanos y en la entidad Integer.
				// Asignar al cambiar estado de los checks también la fecha de hoy.
				if(!Checks.esNulo(dto.getAplicaAsignarMediador())) {
					perimetroActivo.setAplicaAsignarMediador(dto.getAplicaAsignarMediador() ? 1 : 0);
					perimetroActivo.setFechaAplicaAsignarMediador(new Date());
				}
				if(!Checks.esNulo(dto.getAplicaComercializar())) {
					perimetroActivo.setAplicaComercializar(dto.getAplicaComercializar() ? 1 : 0);
					perimetroActivo.setFechaAplicaComercializar(new Date());
				}
				if(!Checks.esNulo(dto.getAplicaFormalizar())) {
					perimetroActivo.setAplicaFormalizar(dto.getAplicaFormalizar() ? 1 : 0);
					perimetroActivo.setFechaAplicaFormalizar(new Date());
				}
				if(!Checks.esNulo(dto.getAplicaGestion())) {
					perimetroActivo.setAplicaGestion(dto.getAplicaGestion() ? 1 : 0);
					perimetroActivo.setFechaAplicaGestion(new Date());
				}
				if(!Checks.esNulo(dto.getAplicaTramiteAdmision())) {
					perimetroActivo.setAplicaTramiteAdmision(dto.getAplicaTramiteAdmision() ? 1 : 0);
					perimetroActivo.setFechaAplicaTramiteAdmision(new Date());
				}

				if (!Checks.esNulo(dto.getMotivoAplicaComercializarCodigo())) {
					DDMotivoComercializacion motivoAplicaComercializar = (DDMotivoComercializacion) diccionarioApi.dameValorDiccionarioByCod(DDMotivoComercializacion.class,  dto.getMotivoAplicaComercializarCodigo());
					perimetroActivo.setMotivoAplicaComercializar(motivoAplicaComercializar);
				}
				
				beanUtilNotNull.copyProperty(perimetroActivo, "motivoNoAplicaComercializar", dto.getMotivoNoAplicaComercializar());
				

				activoApi.saveOrUpdatePerimetroActivo(perimetroActivo);
			}
			
			// --------- Perimetro --> Bloque Comercializción
			if (!Checks.esNulo(dto.getTipoComercializarCodigo())) {
				DDTipoComercializar tipoComercializar = (DDTipoComercializar) diccionarioApi.dameValorDiccionarioByCod(DDTipoComercializar.class,  dto.getTipoComercializarCodigo());
				activo.setTipoComercializar(tipoComercializar);
			}
			//Hace referencia a Destino Comercial (Si te lía el nombre, habla con Fernando)
			if (!Checks.esNulo(dto.getTipoComercializacionCodigo())) {
				DDTipoComercializacion tipoComercializacion = (DDTipoComercializacion) diccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class,  dto.getTipoComercializacionCodigo());
				activo.setTipoComercializacion(tipoComercializacion);
			}
			
			if (!Checks.esNulo(dto.getTipoAlquilerCodigo())) {
				DDTipoAlquiler tipoAlquiler = (DDTipoAlquiler) diccionarioApi.dameValorDiccionarioByCod(DDTipoAlquiler.class,  dto.getTipoAlquilerCodigo());
				activo.setTipoAlquiler(tipoAlquiler);
			}
			
			// Activo bancario -------------
			// Solo se guardan los datos si el usuario ha cambiado algun campo del activo bancario.
			// El control de cambios se realiza revisando los datos que transporta el dto
			// Solo se modifican/crean nuevos registros de activo bancario si hay guardado de datos
			if(
				dto.getClaseActivoCodigo() != null || 
				dto.getClaseActivoDescripcion() != null || 
				dto.getSubtipoClaseActivoCodigo() != null || 
				dto.getSubtipoClaseActivoDescripcion() != null || 
				dto.getNumExpRiesgo() != null || 
				dto.getTipoProductoCodigo() != null || 
				dto.getTipoProductoDescripcion() != null || 
				dto.getEstadoExpRiesgoCodigo() != null || 
				dto.getEstadoExpRiesgoDescripcion() != null || 
				dto.getEstadoExpIncorrienteCodigo() != null || 
				dto.getEstadoExpIncorrienteDescripcion() != null ||
				dto.getProductoDescripcion() != null) 
			{
				
				ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(activo.getId());
				
				beanUtilNotNull.copyProperties(activoBancario, dto);
	
				if(!Checks.esNulo(activoBancario) && Checks.esNulo(activoBancario.getActivo())) {
					activoBancario.setActivo(activo);
				}
				
				if(!Checks.esNulo(dto.getClaseActivoCodigo())) {
					DDClaseActivoBancario claseActivo = (DDClaseActivoBancario) diccionarioApi.dameValorDiccionarioByCod(DDClaseActivoBancario.class, dto.getClaseActivoCodigo());
					activoBancario.setClaseActivo(claseActivo);
				} else {
					DDClaseActivoBancario claseActivo = (DDClaseActivoBancario) diccionarioApi.dameValorDiccionarioByCod(DDClaseActivoBancario.class, DDClaseActivoBancario.CODIGO_INMOBILIARIO);
					activoBancario.setClaseActivo(claseActivo);
				}
				
				if(!Checks.esNulo(dto.getSubtipoClaseActivoCodigo())) {
					DDSubtipoClaseActivoBancario subtipoClaseActivo = (DDSubtipoClaseActivoBancario) diccionarioApi.dameValorDiccionarioByCod(DDSubtipoClaseActivoBancario.class, dto.getSubtipoClaseActivoCodigo());
					activoBancario.setSubtipoClaseActivo(subtipoClaseActivo);
				}
	
				if(!Checks.esNulo(dto.getTipoProductoCodigo())) {
					DDTipoProductoBancario tipoProducto = (DDTipoProductoBancario) diccionarioApi.dameValorDiccionarioByCod(DDTipoProductoBancario.class, dto.getTipoProductoCodigo());
					activoBancario.setTipoProducto(tipoProducto);
				}
				
				if(!Checks.esNulo(dto.getEstadoExpRiesgoCodigo())) {
					DDEstadoExpRiesgoBancario estadoExpRiesgo = (DDEstadoExpRiesgoBancario) diccionarioApi.dameValorDiccionarioByCod(DDEstadoExpRiesgoBancario.class, dto.getEstadoExpRiesgoCodigo());
					activoBancario.setEstadoExpRiesgo(estadoExpRiesgo);
				}
	
				if(!Checks.esNulo(dto.getEstadoExpIncorrienteCodigo())) {
					DDEstadoExpIncorrienteBancario estadoExpIncorriente = (DDEstadoExpIncorrienteBancario) diccionarioApi.dameValorDiccionarioByCod(DDEstadoExpIncorrienteBancario.class, dto.getEstadoExpIncorrienteCodigo());
					activoBancario.setEstadoExpIncorriente(estadoExpIncorriente);
				}
				
				activoApi.saveOrUpdateActivoBancario(activoBancario);
			
			}
			// -----
			
			
			
			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return activo;
	}
}
