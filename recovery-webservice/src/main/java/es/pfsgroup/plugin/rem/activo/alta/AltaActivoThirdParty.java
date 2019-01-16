package es.pfsgroup.plugin.rem.activo.alta;

import java.util.Calendar;
import java.util.Date;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionNoJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.ActivoDistribucion;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoInfAdministrativa;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoLocalComercial;
import es.pfsgroup.plugin.rem.model.ActivoLocalizacion;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPlanDinVentas;
import es.pfsgroup.plugin.rem.model.ActivoPlazaAparcamiento;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoPublicacionHistorico;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoTitulo;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.DtoAltaActivoThirdParty;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.PresupuestoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalificacionEnergetica;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTasacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.ENTIDADES;
import es.pfsgroup.plugin.rem.service.AltaActivoThirdPartyService;


@Component
public class AltaActivoThirdParty implements AltaActivoThirdPartyService {

	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoPatrimonioDao activoPatrimonioDao;

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private RestApi restApi;
	
	
	@Override
	public String[] getKeys() {
		return this.getTipoAltaActivoThirdParty();
	}
	
	@Override
	public String[] getTipoAltaActivoThirdParty() {
		return new String[] { AltaActivoThirdPartyService.CODIGO_ALTA_ACTIVO_THIRD_PARTY };
	}

	@Override
	@Transactional()
	public Boolean procesarAlta(DtoAltaActivoThirdParty dtoAATP) throws Exception {

		// Asignar los datos del DTO al nuevo activo y almacenarlo en la DB.
		Activo activo = this.dtoToEntityActivo(dtoAATP);

		// Si el nuevo activo se ha persistido correctamente, continuar con las demás entidades.
		if (!Checks.esNulo(activo)) {
			this.dtoToEntitiesOtras(dtoAATP, activo);
			this.guardarDatosPatrimonioActivo(dtoAATP, activo);
			restApi.marcarRegistroParaEnvio(ENTIDADES.ACTIVO, activo); //repasar
			
			Auditoria auditoria = new Auditoria();
			auditoria.setBorrado(false);
			auditoria.setFechaCrear(new Date());
			auditoria.setUsuarioCrear("CARGA_MASIVA");
			
			ActivoSituacionPosesoria actSit = new ActivoSituacionPosesoria();
			actSit.setActivo(activo);
			actSit.setVersion(0L);
			actSit.setAuditoria(auditoria);
			
			genericDao.save(ActivoSituacionPosesoria.class, actSit);
			
			ActivoTitulo actTit = new ActivoTitulo();
			actTit.setActivo(activo);
			actTit.setVersion(0L);
			actTit.setAuditoria(auditoria);
			if(!Checks.esNulo(dtoAATP.getFechaInscripcion())){
				actTit.setFechaInscripcionReg(dtoAATP.getFechaInscripcion());
			}
			
			genericDao.save(ActivoTitulo.class, actTit);

		} else {
			return false;
		}

		return true;
	}

	//crea un activo a partir del DtoAltaActivoThirdParty que recibe
	private Activo dtoToEntityActivo(DtoAltaActivoThirdParty dtoAATP) throws Exception{
		DDSubtipoTituloActivo subTipoTitulo = (DDSubtipoTituloActivo) diccionarioApi.dameValorDiccionarioByCod(DDSubtipoTituloActivo.class, dtoAATP.getSubtipoTituloCodigo());
		DDTipoTituloActivo tipoTitulo = subTipoTitulo.getTipoTituloActivo();
		DDSubcartera subcartera = (DDSubcartera) diccionarioApi.dameValorDiccionarioByCod(DDSubcartera.class, dtoAATP.getCodSubCartera());
		DDCartera cartera = subcartera.getCartera();
		Activo activo = new Activo();
		
		beanUtilNotNull.copyProperty(activo, "numActivo", dtoAATP.getNumActivoHaya());
		activo.setNumActivoRem(activoApi.getNextNumActivoRem());
		beanUtilNotNull.copyProperty(activo, "tipoTitulo", tipoTitulo);
		beanUtilNotNull.copyProperty(activo, "subtipoTitulo", utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoTituloActivo.class, dtoAATP.getSubtipoTituloCodigo()));
		beanUtilNotNull.copyProperty(activo, "subcartera", subcartera);
		activo.setCartera(cartera);
		beanUtilNotNull.copyProperty(activo, "tipoActivo", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoActivo.class, dtoAATP.getTipoActivoCodigo()));
		beanUtilNotNull.copyProperty(activo, "subtipoActivo", utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoActivo.class, dtoAATP.getSubtipoActivoCodigo()));
		beanUtilNotNull.copyProperty(activo, "estadoActivo", utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoActivo.class, dtoAATP.getEstadoFisicoCodigo()));
		beanUtilNotNull.copyProperty(activo, "tipoUsoDestino", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoUsoDestino.class, dtoAATP.getUsoDominanteCodigo()));
		beanUtilNotNull.copyProperty(activo, "descripcion", dtoAATP.getDescripcionActivo());
		
		beanUtilNotNull.copyProperty(activo, "tipoComercializacion",
				utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, dtoAATP.getDestinoComercialCodigo()));
		beanUtilNotNull.copyProperty(activo, "tipoAlquiler", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoAlquiler.class, dtoAATP.getTipoAlquilerCodigo()));
				
		activo = genericDao.save(Activo.class, activo);
		return activo;
	}
	
	
private void dtoToEntitiesOtras(DtoAltaActivoThirdParty dtoAATP, Activo activo) throws Exception {
		NMBBien bien = new NMBBien();
		genericDao.save(NMBBien.class, bien);
		
		NMBLocalizacionesBien localizacionBien = new NMBLocalizacionesBien();
		localizacionBien.setBien(bien);
		beanUtilNotNull.copyProperty(localizacionBien, "tipoVia", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoVia.class, dtoAATP.getTipoViaCodigo()));
		beanUtilNotNull.copyProperty(localizacionBien, "nombreVia", dtoAATP.getNombreVia());
		beanUtilNotNull.copyProperty(localizacionBien, "numeroDomicilio", dtoAATP.getNumVia());
		beanUtilNotNull.copyProperty(localizacionBien, "escalera", dtoAATP.getEscalera());
		beanUtilNotNull.copyProperty(localizacionBien, "piso", dtoAATP.getPlanta());
		beanUtilNotNull.copyProperty(localizacionBien, "puerta", dtoAATP.getPuerta());
		beanUtilNotNull.copyProperty(localizacionBien, "unidadPoblacional", utilDiccionarioApi.dameValorDiccionarioByCod(DDUnidadPoblacional.class, dtoAATP.getUnidadMunicipioCodigo()));
		if (!Checks.esNulo(dtoAATP.getMunicipioCodigo())){
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoAATP.getMunicipioCodigo());
			Localidad localidad = genericDao.get(Localidad.class, f1);
			
			if (!Checks.esNulo(localidad)){
				localizacionBien.setLocalidad(localidad);
				beanUtilNotNull.copyProperty(localizacionBien, "provincia", localidad.getProvincia());
			}
		}
		
		beanUtilNotNull.copyProperty(localizacionBien, "pais", utilDiccionarioApi.dameValorDiccionarioByCod(DDCicCodigoIsoCirbeBKP.class, "011")); //España
		beanUtilNotNull.copyProperty(localizacionBien, "codPostal", dtoAATP.getCodigoPostal());
		genericDao.save(NMBLocalizacionesBien.class, localizacionBien);
				
		//ActivoLocalizacion
		ActivoLocalizacion activoLocalizacion = new ActivoLocalizacion();
		activoLocalizacion.setActivo(activo);
		activoLocalizacion.setLocalizacionBien(localizacionBien);
		genericDao.save(ActivoLocalizacion.class, activoLocalizacion);
		
		// PerimetroActivo
		PerimetroActivo perimetroActivo = new PerimetroActivo();
		perimetroActivo.setActivo(activo);
		perimetroActivo.setAplicaGestion(1);
		perimetroActivo.setAplicaComercializar(1);
		if(!Checks.esNulo(dtoAATP.getFormalizacion())){
			perimetroActivo.setAplicaFormalizar(dtoAATP.getFormalizacion().equalsIgnoreCase("si") ? 1 : 0);
		}else perimetroActivo.setAplicaFormalizar(1);
		perimetroActivo.setAplicaPublicar(true);
		perimetroActivo.setIncluidoEnPerimetro(1);
		genericDao.save(PerimetroActivo.class, perimetroActivo);
		
		
		// Información registral
		NMBInformacionRegistralBien nmbInfRegistralBien = new NMBInformacionRegistralBien();
		nmbInfRegistralBien.setBien(bien);
		

		if (!Checks.esNulo(dtoAATP.getPoblacionRegistroCodigo())){
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoAATP.getPoblacionRegistroCodigo());
			Localidad localidad = genericDao.get(Localidad.class, f1);
			if (!Checks.esNulo(localidad)){
				nmbInfRegistralBien.setLocalidad(localidad);
				nmbInfRegistralBien.setProvincia(localidad.getProvincia());
			}
		}
		
		beanUtilNotNull.copyProperty(nmbInfRegistralBien, "numRegistro", dtoAATP.getNumRegistro());
		beanUtilNotNull.copyProperty(nmbInfRegistralBien, "tomo", dtoAATP.getTomoRegistro());
		beanUtilNotNull.copyProperty(nmbInfRegistralBien, "libro", dtoAATP.getLibroRegistro());
		beanUtilNotNull.copyProperty(nmbInfRegistralBien, "folio", dtoAATP.getFolioRegistro());
		beanUtilNotNull.copyProperty(nmbInfRegistralBien, "numFinca", dtoAATP.getFincaRegistro());
		beanUtilNotNull.copyProperty(nmbInfRegistralBien, "superficieConstruida", dtoAATP.getSuperficieConstruidaRegistro());
		
		nmbInfRegistralBien = genericDao.save(NMBInformacionRegistralBien.class, nmbInfRegistralBien);
		
		
		
		
		ActivoInfoRegistral activoInforRegistral = new ActivoInfoRegistral();
		activoInforRegistral.setInfoRegistralBien(nmbInfRegistralBien);
		activoInforRegistral.setActivo(activo);
		
		beanUtilNotNull.copyProperty(activoInforRegistral, "idufir", dtoAATP.getIdufirCruRegistro());
		beanUtilNotNull.copyProperty(activoInforRegistral, "superficieElementosComunes", dtoAATP.getSuperficieRepercusionEECCRegistro());
		beanUtilNotNull.copyProperty(activoInforRegistral, "superficieParcela", dtoAATP.getParcelaRegistro());
		beanUtilNotNull.copyProperty(activoInforRegistral, "superficieutil", dtoAATP.getSuperficieUtilRegistro());
		if (!Checks.esNulo(dtoAATP.getEsIntegradoDivHorizontalRegistro())){
			beanUtilNotNull.copyProperty(activoInforRegistral, "divHorInscrito", dtoAATP.getEsIntegradoDivHorizontalRegistro().equalsIgnoreCase("si") ? 1 : 0);
		}
		genericDao.save(ActivoInfoRegistral.class, activoInforRegistral);
		
		
		
		//ActivoPropietarioActivo
		ActivoPropietario activoPropietario = genericDao.get(ActivoPropietario.class, genericDao.createFilter(FilterType.EQUALS, "docIdentificativo",dtoAATP.getNifPropietario()));
		if(Checks.esNulo(activoPropietario)){
			activoPropietario = new ActivoPropietario();
			activoPropietario.setDocIdentificativo(dtoAATP.getNifPropietario());
			DDTipoDocumento tipoDocumento = genericDao.get(DDTipoDocumento.class, genericDao.createFilter(FilterType.EQUALS, "codigo","15"));
			activoPropietario.setTipoDocIdentificativo(tipoDocumento);
			activoPropietario = genericDao.save(ActivoPropietario.class, activoPropietario);
		}
		
		ActivoPropietarioActivo activoPropietarioActivo = new ActivoPropietarioActivo();
		activoPropietarioActivo.setActivo(activo);
		activoPropietarioActivo.setPropietario(activoPropietario);
		beanUtilNotNull.copyProperty(activoPropietarioActivo, "porcPropiedad", dtoAATP.getPercentParticipacionPropiedad());
		beanUtilNotNull.copyProperty(activoPropietarioActivo, "tipoGradoPropiedad", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoGradoPropiedad.class, dtoAATP.getGradoPropiedadCodigo()));
		genericDao.save(ActivoPropietarioActivo.class, activoPropietarioActivo);
		
		//ActivoCatastro
		ActivoCatastro catastro = new ActivoCatastro();
		catastro.setActivo(activo);
		beanUtilNotNull.copyProperty(catastro, "refCatastral", dtoAATP.getReferenciaCatastral());
		genericDao.save(ActivoCatastro.class, catastro);
		
		//ActivoInfAdministrativa
		ActivoInfAdministrativa activoInfAdministrativa = new ActivoInfAdministrativa();
		activoInfAdministrativa.setActivo(activo);
		if(!Checks.esNulo(dtoAATP.getEsVPO())){
			beanUtilNotNull.copyProperty(activoInfAdministrativa, "sueloVpo", dtoAATP.getEsVPO().equalsIgnoreCase("si") ? 1 : 0);
		}else {
			beanUtilNotNull.copyProperty(activoInfAdministrativa, "sueloVpo", 0);
		}
		genericDao.save(ActivoInfAdministrativa.class, activoInfAdministrativa);
		
		//ActivoConfigDocumento
		ActivoConfigDocumento configDocumento = new ActivoConfigDocumento();
		beanUtilNotNull.copyProperty(configDocumento, "tipoDocumentoActivo", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumentoActivo.class, DDTipoDocumentoActivo.CODIGO_CEE));
		configDocumento = genericDao.save(ActivoConfigDocumento.class, configDocumento);
		
		//ActivoAdmisionDocumento
		ActivoAdmisionDocumento admisionDocumento = new ActivoAdmisionDocumento();
		admisionDocumento.setActivo(activo);
		admisionDocumento.setConfigDocumento(configDocumento);
		beanUtilNotNull.copyProperty(admisionDocumento, "tipoCalificacionEnergetica", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCalificacionEnergetica.class, dtoAATP.getCalificacionCeeCodigo()));
		genericDao.save(ActivoAdmisionDocumento.class, admisionDocumento);
		
		//ActivoInfoComercial
		ActivoVivienda activoVivienda = new ActivoVivienda();
		ActivoLocalComercial activoLocalComercial= new ActivoLocalComercial();
		ActivoPlazaAparcamiento activoPlazaAparcamiento= new ActivoPlazaAparcamiento();
		ActivoInfoComercial activoInfoComercialDos= new ActivoInfoComercial();
		
		if(DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())){
			ActivoVivienda vivienda = new ActivoVivienda();
			vivienda.setActivo(activo);
			vivienda.setTipoActivo(activo.getTipoActivo());
			vivienda.setNumPlantasInter(dtoAATP.getNumPlantasVivienda());

			if(!Checks.esNulo(dtoAATP.getNifMediador())){
				Filter f1 = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", dtoAATP.getNifMediador());
				Filter f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_MEDIADOR);
				ActivoProveedor mediador = genericDao.get(ActivoProveedor.class, f1, f2);
				if(Checks.esNulo(mediador)){
					f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA);
					mediador = genericDao.get(ActivoProveedor.class, f1, f2);
				}
				vivienda.setMediadorInforme(mediador);
			}

			beanUtilNotNull.copyProperty(vivienda, "planta", dtoAATP.getNumPlantasVivienda());
			activoVivienda = vivienda;
			genericDao.save(ActivoVivienda.class, vivienda);
		} else if (DDTipoActivo.COD_COMERCIAL.equals(activo.getTipoActivo().getCodigo())){
			ActivoLocalComercial localComercial = new ActivoLocalComercial();
			localComercial.setActivo(activo);
			localComercial.setTipoActivo(activo.getTipoActivo());

			if(!Checks.esNulo(dtoAATP.getNifMediador())){
				Filter f1 = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", dtoAATP.getNifMediador());
				Filter f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_MEDIADOR);
				ActivoProveedor mediador = genericDao.get(ActivoProveedor.class, f1, f2);
				if(Checks.esNulo(mediador)){
					f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA);
					mediador = genericDao.get(ActivoProveedor.class, f1, f2);
				}
				localComercial.setMediadorInforme(mediador);
			}

			beanUtilNotNull.copyProperty(localComercial, "planta", dtoAATP.getNumPlantasVivienda());
			activoLocalComercial = localComercial;
			genericDao.save(ActivoLocalComercial.class, localComercial);
		} else if (DDTipoActivo.COD_OTROS.equals(activo.getTipoActivo().getCodigo())){
			ActivoPlazaAparcamiento aparcamiento = new ActivoPlazaAparcamiento();
			aparcamiento.setActivo(activo);
			aparcamiento.setTipoActivo(activo.getTipoActivo());

			if (!Checks.esNulo(dtoAATP.getNifMediador())){
				Filter f1 = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", dtoAATP.getNifMediador());
				Filter f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_MEDIADOR);
				ActivoProveedor mediador = genericDao.get(ActivoProveedor.class, f1, f2);
				if(Checks.esNulo(mediador)){
					f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA);
					mediador = genericDao.get(ActivoProveedor.class, f1, f2);
				}
				aparcamiento.setMediadorInforme(mediador);
			}

			beanUtilNotNull.copyProperty(aparcamiento, "planta", dtoAATP.getNumPlantasVivienda());
			activoPlazaAparcamiento = aparcamiento;
			genericDao.save(ActivoPlazaAparcamiento.class, aparcamiento);
		} else {
			ActivoInfoComercial activoInfoComercial = new ActivoInfoComercial();
			activoInfoComercial.setActivo(activo);
			activoInfoComercial.setTipoActivo(activo.getTipoActivo());

			if (!Checks.esNulo(dtoAATP.getNifMediador())){
				Filter f1 = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", dtoAATP.getNifMediador());
				Filter f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_MEDIADOR);
				ActivoProveedor mediador = genericDao.get(ActivoProveedor.class, f1, f2);
				if(Checks.esNulo(mediador)){
					f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA);
					mediador = genericDao.get(ActivoProveedor.class, f1, f2);
				}
				activoInfoComercial.setMediadorInforme(mediador);
			}

			beanUtilNotNull.copyProperty(activoInfoComercial, "planta", dtoAATP.getNumPlantasVivienda());
			activoInfoComercialDos = activoInfoComercial;
			genericDao.save(ActivoInfoComercial.class, activoInfoComercial);
		}
		
		//Baños
		if (!Checks.esNulo(dtoAATP.getNumBanyosVivienda()) && dtoAATP.getNumBanyosVivienda() > 0){
			ActivoDistribucion banyo = new ActivoDistribucion();
			if(DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())){
				banyo.setInfoComercial(activoVivienda);
			}
			else if(DDTipoActivo.COD_COMERCIAL.equals(activo.getTipoActivo().getCodigo())){
				banyo.setInfoComercial(activoLocalComercial);
			}
			else if(DDTipoActivo.COD_OTROS.equals(activo.getTipoActivo().getCodigo())){
				banyo.setInfoComercial(activoPlazaAparcamiento);
			}
			else{
				banyo.setInfoComercial(activoInfoComercialDos);
			}
			banyo.setNumPlanta(0);
			banyo.setCantidad(dtoAATP.getNumBanyosVivienda());
			banyo.setTipoHabitaculo((DDTipoHabitaculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoHabitaculo.class, DDTipoHabitaculo.TIPO_HABITACULO_BANYO));
			genericDao.save(ActivoDistribucion.class, banyo);
		}
		
		//Aseos
		if (!Checks.esNulo(dtoAATP.getNumAseosVivienda()) && dtoAATP.getNumAseosVivienda() > 0) {
			ActivoDistribucion aseos = new ActivoDistribucion();
			if(DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())){
				aseos.setInfoComercial(activoVivienda);
			}
			else if (DDTipoActivo.COD_COMERCIAL.equals(activo.getTipoActivo().getCodigo())){
				aseos.setInfoComercial(activoLocalComercial);
			}
			else if (DDTipoActivo.COD_OTROS.equals(activo.getTipoActivo().getCodigo())){
				aseos.setInfoComercial(activoPlazaAparcamiento);
			}
			else{
				aseos.setInfoComercial(activoInfoComercialDos);
			}
			aseos.setNumPlanta(0);
			aseos.setCantidad(dtoAATP.getNumAseosVivienda());
			aseos.setTipoHabitaculo((DDTipoHabitaculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoHabitaculo.class, DDTipoHabitaculo.TIPO_HABITACULO_ASEO));
			genericDao.save(ActivoDistribucion.class, aseos);
		}
		
		// Dormitorios.
				if (!Checks.esNulo(dtoAATP.getNumDormitoriosVivienda()) && dtoAATP.getNumDormitoriosVivienda() > 0) {
					ActivoDistribucion dormitorio = new ActivoDistribucion();
					if(DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())){
						dormitorio.setInfoComercial(activoVivienda);
					}
					else if(DDTipoActivo.COD_COMERCIAL.equals(activo.getTipoActivo().getCodigo())){
						dormitorio.setInfoComercial(activoLocalComercial);
					}
					else if(DDTipoActivo.COD_OTROS.equals(activo.getTipoActivo().getCodigo())){
						dormitorio.setInfoComercial(activoPlazaAparcamiento);
					}
					else{
						dormitorio.setInfoComercial(activoInfoComercialDos);
					}
					dormitorio.setNumPlanta(0);
					dormitorio.setCantidad(dtoAATP.getNumDormitoriosVivienda());
					dormitorio.setTipoHabitaculo((DDTipoHabitaculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoHabitaculo.class, DDTipoHabitaculo.TIPO_HABITACULO_DORMITORIO));
					genericDao.save(ActivoDistribucion.class, dormitorio);
				}

				// Garaje Anejo.
				if (!Checks.esNulo(dtoAATP.getGarajeAnejo()) && dtoAATP.getGarajeAnejo().equalsIgnoreCase("si")) {
					ActivoDistribucion garajeAnejo = new ActivoDistribucion();
					if(DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())){
						garajeAnejo.setInfoComercial(activoVivienda);
					}
					else if(DDTipoActivo.COD_COMERCIAL.equals(activo.getTipoActivo().getCodigo())){
						garajeAnejo.setInfoComercial(activoLocalComercial);
					}
					else if(DDTipoActivo.COD_OTROS.equals(activo.getTipoActivo().getCodigo())){
						garajeAnejo.setInfoComercial(activoPlazaAparcamiento);
					}
					else{
						garajeAnejo.setInfoComercial(activoInfoComercialDos);
					}
					garajeAnejo.setNumPlanta(0);
					garajeAnejo.setCantidad(1);
					garajeAnejo.setTipoHabitaculo((DDTipoHabitaculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoHabitaculo.class, DDTipoHabitaculo.TIPO_HABITACULO_GARAJE));
					genericDao.save(ActivoDistribucion.class, garajeAnejo);
				}
				
				// Trastero Anejo.
				if (!Checks.esNulo(dtoAATP.getTrasteroAnejo()) && dtoAATP.getTrasteroAnejo().equalsIgnoreCase("si")) {
					ActivoDistribucion trasteroAnejo = new ActivoDistribucion();
					if(DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())){
						trasteroAnejo.setInfoComercial(activoVivienda);
					}
					else if(DDTipoActivo.COD_COMERCIAL.equals(activo.getTipoActivo().getCodigo())){
						trasteroAnejo.setInfoComercial(activoLocalComercial);
					}
					else if(DDTipoActivo.COD_OTROS.equals(activo.getTipoActivo().getCodigo())){
						trasteroAnejo.setInfoComercial(activoPlazaAparcamiento);
					}
					else{
						trasteroAnejo.setInfoComercial(activoInfoComercialDos);
					}
					trasteroAnejo.setNumPlanta(0);
					trasteroAnejo.setCantidad(1);
					trasteroAnejo.setTipoHabitaculo((DDTipoHabitaculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoHabitaculo.class, DDTipoHabitaculo.TIPO_HABITACULO_TRASTERO));
					genericDao.save(ActivoDistribucion.class, trasteroAnejo);
				}
				
				// ActivoEdificio.
				ActivoEdificio activoEdificio = new ActivoEdificio();
				if(DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())){
					activoEdificio.setInfoComercial(activoVivienda);
				}
				else if(DDTipoActivo.COD_COMERCIAL.equals(activo.getTipoActivo().getCodigo())){
					activoEdificio.setInfoComercial(activoLocalComercial);
				}
				else if(DDTipoActivo.COD_OTROS.equals(activo.getTipoActivo().getCodigo())){
					activoEdificio.setInfoComercial(activoPlazaAparcamiento);
				}
				else{
					activoEdificio.setInfoComercial(activoInfoComercialDos);
				}
				if (!Checks.esNulo(dtoAATP.getAscensor())) {
					activoEdificio.setAscensorEdificio(dtoAATP.getAscensor().equalsIgnoreCase("si") ? 1 : 0);
				}
				genericDao.save(ActivoEdificio.class, activoEdificio);
				
				//Gestores				
				EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GCOM");
				Filter f1 = genericDao.createFilter(FilterType.EQUALS, "username", dtoAATP.getGestorComercial());
				Usuario usu = genericDao.get(Usuario.class, f1);
				GestorEntidadDto dto = new GestorEntidadDto();
				dto.setIdEntidad(activo.getId());
				dto.setIdUsuario(usu.getId());
				dto.setIdTipoGestor(tipoGestorComercial.getId());
				activoAdapter.insertarGestorAdicional(dto);
				
				
				EXTDDTipoGestor tipoSupervisorComercial = (EXTDDTipoGestor) utilDiccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SCOM");
				Filter f2 = genericDao.createFilter(FilterType.EQUALS, "username", dtoAATP.getSupervisorGestorComercial());
				Usuario usu2 = genericDao.get(Usuario.class, f2);
				GestorEntidadDto dto2 = new GestorEntidadDto();
				dto2.setIdEntidad(activo.getId());
				dto2.setIdUsuario(usu2.getId());
				dto2.setIdTipoGestor(tipoSupervisorComercial.getId());
				activoAdapter.insertarGestorAdicional(dto2);
				
				
				if (!Checks.esNulo(dtoAATP.getGestorFormalizacion())){
					EXTDDTipoGestor tipoGestorFormalizacion = (EXTDDTipoGestor) utilDiccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GFORM");
					Filter f3 = genericDao.createFilter(FilterType.EQUALS, "username", dtoAATP.getGestorFormalizacion());
					Usuario usu3 = genericDao.get(Usuario.class, f3);
					GestorEntidadDto dto3 = new GestorEntidadDto();
					dto3.setIdEntidad(activo.getId());
					dto3.setIdUsuario(usu3.getId());
					dto3.setIdTipoGestor(tipoGestorFormalizacion.getId());
					activoAdapter.insertarGestorAdicional(dto3);
				}
				
				
				EXTDDTipoGestor tipoSupervisorFormalizacion = (EXTDDTipoGestor) utilDiccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SFORM");
				Filter f4 = genericDao.createFilter(FilterType.EQUALS, "username", dtoAATP.getSupervisorGestorFormalizacion());
				Usuario usu4 = genericDao.get(Usuario.class, f4);
				GestorEntidadDto dto4 = new GestorEntidadDto();
				dto4.setIdEntidad(activo.getId());
				dto4.setIdUsuario(usu4.getId());
				dto4.setIdTipoGestor(tipoSupervisorFormalizacion.getId());
				activoAdapter.insertarGestorAdicional(dto4);
				
				EXTDDTipoGestor tipoGestorAdmision = (EXTDDTipoGestor) utilDiccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GADM");
				Filter f5 = genericDao.createFilter(FilterType.EQUALS, "username", dtoAATP.getGestorAdmision());
				Usuario usu5 = genericDao.get(Usuario.class, f5);
				GestorEntidadDto dto5 = new GestorEntidadDto();
				dto5.setIdEntidad(activo.getId());
				dto5.setIdUsuario(usu5.getId());
				dto5.setIdTipoGestor(tipoGestorAdmision.getId());
				activoAdapter.insertarGestorAdicional(dto5);
				
				EXTDDTipoGestor tipoGestorActivos = (EXTDDTipoGestor) utilDiccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GACT");
				Filter f6 = genericDao.createFilter(FilterType.EQUALS, "username", dtoAATP.getGestorActivos());
				Usuario usu6 = genericDao.get(Usuario.class, f6);
				GestorEntidadDto dto6 = new GestorEntidadDto();
				dto6.setIdEntidad(activo.getId());
				dto6.setIdUsuario(usu6.getId());
				dto6.setIdTipoGestor(tipoGestorActivos.getId());
				activoAdapter.insertarGestorAdicional(dto6);
				
				if (!Checks.esNulo(dtoAATP.getGestoriaDeFormalizacion())){
					EXTDDTipoGestor tipoGestoriaFormalizacion = (EXTDDTipoGestor) utilDiccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GIAFORM");
					Filter f7 = genericDao.createFilter(FilterType.EQUALS, "username", dtoAATP.getGestoriaDeFormalizacion());
					Usuario usu7 = genericDao.get(Usuario.class, f7);
					GestorEntidadDto dto7 = new GestorEntidadDto();
					dto7.setIdEntidad(activo.getId());
					dto7.setIdUsuario(usu7.getId());
					dto7.setIdTipoGestor(tipoGestoriaFormalizacion.getId());
					activoAdapter.insertarGestorAdicional(dto7);
				}
				
				//ActivoValoracion - Precio mínimo
				ActivoValoraciones activoValoracionPrecioMinimo = new ActivoValoraciones();
				activoValoracionPrecioMinimo.setFechaCarga(new Date());
				activoValoracionPrecioMinimo.setFechaInicio(new Date());
				activoValoracionPrecioMinimo.setActivo(activo);
				activoValoracionPrecioMinimo.setTipoPrecio((DDTipoPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPrecio.class, DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO));
				beanUtilNotNull.copyProperty(activoValoracionPrecioMinimo, "importe", dtoAATP.getPrecioMinimo());
				//activoValoracionPrecioMinimo.set
				genericDao.save(ActivoValoraciones.class, activoValoracionPrecioMinimo);
				
				
				//ActivoValoracion - Precio venta web
				ActivoValoraciones activoValoracionPrecioVentaWeb = new ActivoValoraciones();
				activoValoracionPrecioVentaWeb.setFechaCarga(new Date());
				activoValoracionPrecioVentaWeb.setFechaInicio(new Date());
				activoValoracionPrecioVentaWeb.setActivo(activo);
				activoValoracionPrecioVentaWeb.setTipoPrecio((DDTipoPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPrecio.class, DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA));
				beanUtilNotNull.copyProperty(activoValoracionPrecioVentaWeb, "importe", dtoAATP.getPrecioVentaWeb());
				genericDao.save(ActivoValoraciones.class, activoValoracionPrecioVentaWeb);
				
				//NMBValoracionesBien
				NMBValoracionesBien bienValoracion = new NMBValoracionesBien();
				bienValoracion.setBien(bien);
				beanUtilNotNull.copyProperty(bienValoracion, "fechaValorTasacion", dtoAATP.getFechaTasacion());
				bienValoracion = genericDao.save(NMBValoracionesBien.class, bienValoracion);
				
				// ActivoTasacion
				ActivoTasacion activoTasacion = new ActivoTasacion();
				activoTasacion.setActivo(activo);
				activoTasacion.setValoracionBien(bienValoracion);
				activoTasacion.setCodigoFirma(0L);
				beanUtilNotNull.copyProperty(activoTasacion, "tipoTasacion", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoTasacion.class, DDTipoTasacion.TIPO_ASESORAMIENTO_COMERCIAL));
				beanUtilNotNull.copyProperty(activoTasacion, "importeTasacionFin", dtoAATP.getValorTasacion());
				genericDao.save(ActivoTasacion.class, activoTasacion);
				
				
				//ActivoBancario
				String str = dtoAATP.getTipoActivo();
				String claseActivo = str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
				ActivoBancario activoBancario = new ActivoBancario();
				activoBancario.setActivo(activo);
				beanUtilNotNull.copyProperty(activoBancario, "claseActivo", utilDiccionarioApi.dameValorDiccionarioByDes(DDClaseActivoBancario.class, claseActivo));
				genericDao.save(ActivoBancario.class, activoBancario);
				if(DDClaseActivoBancario.CODIGO_INMOBILIARIO.equals(activoBancario.getClaseActivo().getCodigo())){
					PresupuestoActivo presupuesto = new PresupuestoActivo();
					presupuesto.setImporteInicial(50000.00);
					presupuesto.setActivo(activo);
					
					Calendar cal = Calendar.getInstance();
					String anyo = ((Integer) cal.get(Calendar.YEAR)).toString();
					Ejercicio ej = genericDao.get(Ejercicio.class, genericDao.createFilter(FilterType.EQUALS, "anyo", anyo));
					presupuesto.setEjercicio(ej);
					
					presupuesto.setFechaAsignacion(new Date());
					
					Auditoria auditoria = new Auditoria();
					auditoria.setUsuarioCrear("CARGA_MASIVA");
					auditoria.setFechaCrear(new Date());
					presupuesto.setAuditoria(auditoria);
					
					genericDao.save(PresupuestoActivo.class, presupuesto);
				}
				if (activo.getTipoTitulo().getCodigo().equals(DDTipoTituloActivo.tipoTituloPDV)){
					ActivoPlanDinVentas planDinVentas = new ActivoPlanDinVentas();
					planDinVentas.setActivo(activo);
					genericDao.save(ActivoPlanDinVentas.class, planDinVentas);
				}else if (activo.getTipoTitulo().getCodigo().equals(DDTipoTituloActivo.tipoTituloJudicial)) {
					NMBAdjudicacionBien adjudicacionBien = new NMBAdjudicacionBien();
					adjudicacionBien.setBien(bien);
					if(!Checks.esNulo(dtoAATP.getFechaTomaPosesion())){
						adjudicacionBien.setFechaRealizacionPosesion(dtoAATP.getFechaTomaPosesion());
					}
					genericDao.save(NMBAdjudicacionBien.class, adjudicacionBien);
					
					//ActivoAdjudicacionJudicial
					ActivoAdjudicacionJudicial activoAdjudicacionJudicial = new ActivoAdjudicacionJudicial();
					activoAdjudicacionJudicial.setActivo(activo);
					activoAdjudicacionJudicial.setAdjudicacionBien(adjudicacionBien);
					genericDao.save(ActivoAdjudicacionJudicial.class,activoAdjudicacionJudicial);
				}else if (activo.getTipoTitulo().getCodigo().equals(DDTipoTituloActivo.tipoTituloNoJudicial)) {
					//ActivoAdjudicacionNoJudicial
					ActivoAdjudicacionNoJudicial activoAdjudicacionNoJudicial = new ActivoAdjudicacionNoJudicial();
					activoAdjudicacionNoJudicial.setActivo(activo);
					if(!Checks.esNulo(dtoAATP.getFechaTomaPosesion())){
						activoAdjudicacionNoJudicial.setFechaTitulo(dtoAATP.getFechaTomaPosesion());
					}
					genericDao.save(ActivoAdjudicacionNoJudicial.class, activoAdjudicacionNoJudicial);
				}
				
		activo.setBien(bien);
		genericDao.save(Activo.class, activo);

		ActivoPublicacion activoPublicacion = new ActivoPublicacion();
		activoPublicacion.setActivo(activo);
		activoPublicacion.setTipoComercializacion((DDTipoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, dtoAATP.getDestinoComercialCodigo()));
		activoPublicacion.setEstadoPublicacionVenta((DDEstadoPublicacionVenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacionVenta.class, DDEstadoPublicacionVenta.CODIGO_NO_PUBLICADO_VENTA));
		activoPublicacion.setEstadoPublicacionAlquiler((DDEstadoPublicacionAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacionAlquiler.class, DDEstadoPublicacionAlquiler.CODIGO_NO_PUBLICADO_ALQUILER));
		activoPublicacion.setCheckPublicarVenta(false);
		activoPublicacion.setCheckOcultarVenta(false);
		activoPublicacion.setCheckSinPrecioVenta(false);
		activoPublicacion.setCheckOcultarPrecioVenta(false);
		activoPublicacion.setCheckPublicarAlquiler(false);
		activoPublicacion.setCheckOcultarAlquiler(false);
		activoPublicacion.setCheckSinPrecioAlquiler(false);
		activoPublicacion.setCheckOcultarPrecioAlquiler(false);
		activoPublicacion.setVersion(0L);

		Auditoria auditoria = new Auditoria();
		auditoria.setBorrado(false);
		auditoria.setFechaCrear(new Date());
		auditoria.setUsuarioCrear("CARGA_MASIVA");
		activoPublicacion.setAuditoria(auditoria);

		genericDao.save(ActivoPublicacion.class, activoPublicacion);

		ActivoPublicacionHistorico activoPublicacionHistorico = new ActivoPublicacionHistorico();
		BeanUtils.copyProperties(activoPublicacionHistorico, activoPublicacion);
		genericDao.save(ActivoPublicacionHistorico.class, activoPublicacionHistorico);
	}


	private void guardarDatosPatrimonioActivo(DtoAltaActivoThirdParty dtoAATP, Activo activo) throws Exception {
		if (!Checks.esNulo(activo)) {
			ActivoPatrimonio activoPatrimonio = activoPatrimonioDao.getActivoPatrimonioByActivo(activo.getId());
			if(Checks.esNulo(activoPatrimonio)){
				activoPatrimonio = new ActivoPatrimonio();
				activoPatrimonio.setActivo(activo);

			}
			if (Checks.esNulo(activoPatrimonio.getTipoEstadoAlquiler())) {
				Filter f1 = genericDao.createFilter(FilterType.EQUALS, "DD_EAL_CODIGO", DDTipoEstadoAlquiler.ESTADO_ALQUILER_LIBRE);
				DDTipoEstadoAlquiler estadoAlquiler = genericDao.get(DDTipoEstadoAlquiler.class, f1);
				activoPatrimonio.setTipoEstadoAlquiler(estadoAlquiler);
			}
			genericDao.save(ActivoPatrimonio.class, activoPatrimonio);
		}
	}

}
