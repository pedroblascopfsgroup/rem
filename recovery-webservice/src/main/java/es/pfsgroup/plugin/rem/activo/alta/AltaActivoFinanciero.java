package es.pfsgroup.plugin.rem.activo.alta;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
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
import es.pfsgroup.plugin.rem.model.DtoAltaActivoFinanciero;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.HistoricoOcupadoTitulo;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.PresupuestoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpRiesgoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalificacionEnergetica;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTasacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;
import es.pfsgroup.plugin.rem.service.AltaActivoService;
import es.pfsgroup.recovery.api.UsuarioApi;

@Component
public class AltaActivoFinanciero implements AltaActivoService {

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	private GenericAdapter adapter;
	@Autowired
	private ActivoPatrimonioDao activoPatrimonioDao;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	
	@Autowired
	private GestorActivoApi gestorActivoManager;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	public String[] getKeys() {
		return this.getTipoAltaActivo();
	}

	@Override
	public String[] getTipoAltaActivo() {
		return new String[] { AltaActivoService.CODIGO_ALTA_ACTIVO_FINANCIERO };
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean procesarAlta(DtoAltaActivoFinanciero dtoAAF) throws Exception {

		// Asignar los datos del DTO al nuevo activo y almacenarlo en la DB.
		Activo activo = this.dtoToEntityActivo(dtoAAF);

		// Si el nuevo activo se ha persistido correctamente, continuar con las demás entidades.
		if (!Checks.esNulo(activo)) {
			this.dtoToEntitiesOtras(dtoAAF, activo);
			this.guardarDatosPatrimonioActivo( dtoAAF, activo);
			
			Auditoria auditoria = new Auditoria();
			auditoria.setBorrado(false);
			auditoria.setFechaCrear(new Date());
			auditoria.setUsuarioCrear("CARGA_MASIVA");
			
			ActivoSituacionPosesoria actSit = new ActivoSituacionPosesoria();
			actSit.setActivo(activo);
			actSit.setAccesoAntiocupa(0);
			actSit.setAccesoTapiado(0);		
			actSit.setOcupado(0);
			Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			String usuarioModificar = usu == null ? AltaActivoService.CODIGO_ALTA_ACTIVO_FINANCIERO : AltaActivoService.CODIGO_ALTA_ACTIVO_FINANCIERO + usu.getUsername();
			actSit.setUsuarioModificarOcupado(usuarioModificar);
			actSit.setFechaModificarOcupado(new Date());
			actSit.setComboOtro(0);
			actSit.setVersion(new Long(0));
			actSit.setAuditoria(auditoria);
			
			genericDao.save(ActivoSituacionPosesoria.class, actSit);
			ActivoTitulo actTit = new ActivoTitulo();
			actTit.setActivo(activo);
			actTit.setVersion(new Long(0));
			actTit.setAuditoria(auditoria);			
			genericDao.save(ActivoTitulo.class, actTit);
			
			if(activo!=null && actSit!=null && usu!=null) {			
					HistoricoOcupadoTitulo histOcupado = new HistoricoOcupadoTitulo(activo,actSit,usu,HistoricoOcupadoTitulo.COD_ALTA_ACTIVO,null);
					genericDao.save(HistoricoOcupadoTitulo.class, histOcupado);					
			}
			
		} else {
			return false;
		}

		return true;
	}

	private Activo dtoToEntityActivo(DtoAltaActivoFinanciero dtoAAF) throws Exception {
		Activo activo = new Activo();
		DDSinSiNo siNoObraNueva = (DDSinSiNo)diccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, DDSinSiNo.CODIGO_NO);

		beanUtilNotNull.copyProperty(activo, "numActivo", dtoAAF.getNumActivoHaya());
		activo.setNumActivoRem(activoApi.getNextNumActivoRem());
		beanUtilNotNull.copyProperty(activo, "tipoTitulo", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoTituloActivo.class, dtoAAF.getTipoTituloCodigo()));
		beanUtilNotNull.copyProperty(activo, "subtipoTitulo", utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoTituloActivo.class, dtoAAF.getSubtipoTituloCodigo()));
		beanUtilNotNull.copyProperty(activo, "cartera", utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class, dtoAAF.getCarteraCodigo()));
		beanUtilNotNull.copyProperty(activo, "subcartera", utilDiccionarioApi.dameValorDiccionarioByCod(DDSubcartera.class, dtoAAF.getSubcarteraCodigo()));
		if (!Checks.esNulo(activo.getCartera())) {
			// Establecer el 'num activo cartera'.
			if (DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) {
				beanUtilNotNull.copyProperty(activo, "numActivoUvem", dtoAAF.getNumActivoCartera());
			} else if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())) {
				beanUtilNotNull.copyProperty(activo, "numActivo", dtoAAF.getNumActivoCartera());
			} else if (DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo())) {
				beanUtilNotNull.copyProperty(activo, "idSareb", dtoAAF.getNumActivoCartera());
			}
		}
		beanUtilNotNull.copyProperty(activo, "idRecovery", dtoAAF.getIdAsuntoRecovery());
		beanUtilNotNull.copyProperty(activo, "tipoActivo", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoActivo.class, dtoAAF.getTipoActivoCodigo()));
		beanUtilNotNull.copyProperty(activo, "subtipoActivo", utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoActivo.class, dtoAAF.getSubtipoActivoCodigo()));
		beanUtilNotNull.copyProperty(activo, "estadoActivo", utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoActivo.class, dtoAAF.getEstadoFisicoCodigo()));
		beanUtilNotNull.copyProperty(activo, "tipoUsoDestino", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoUsoDestino.class, dtoAAF.getUsoDominanteCodigo()));
		beanUtilNotNull.copyProperty(activo, "descripcion", dtoAAF.getDescripcionActivo());
		beanUtilNotNull.copyProperty(activo, "tipoComercializacion",
				utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, dtoAAF.getDestinoComercialCodigo()));
		beanUtilNotNull.copyProperty(activo, "tipoAlquiler", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoAlquiler.class, dtoAAF.getTipoAlquilerCodigo()));
		beanUtilNotNull.copyProperty(activo, "situacionComercial",
				utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionComercial.class, DDSituacionComercial.CODIGO_NO_COMERCIALIZABLE));
		beanUtilNotNull.copyProperty(activo, "tipoComercializar", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializar.class, dtoAAF.getTipoDeComercializacion()));
		activo.setTieneObraNuevaAEfectosComercializacion(siNoObraNueva);
		
		activo = genericDao.save(Activo.class, activo);
		return activo;
	}

	private void dtoToEntitiesOtras(DtoAltaActivoFinanciero dtoAAF, Activo activo) throws Exception {

		// NMBien.
		NMBBien bien = new NMBBien();
		beanUtilNotNull.copyProperty(bien, "sarebId", dtoAAF.getNumBienRecovery());
		bien = genericDao.save(NMBBien.class, bien);

		// Localización Bien.
		NMBLocalizacionesBien localizacionBien = new NMBLocalizacionesBien();
		localizacionBien.setBien(bien);
		beanUtilNotNull.copyProperty(localizacionBien, "tipoVia", utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoVia.class, dtoAAF.getTipoViaCodigo()));
		beanUtilNotNull.copyProperty(localizacionBien, "nombreVia", dtoAAF.getNombreVia());
		beanUtilNotNull.copyProperty(localizacionBien, "numeroDomicilio", dtoAAF.getNumVia());
		beanUtilNotNull.copyProperty(localizacionBien, "escalera", dtoAAF.getEscalera());
		beanUtilNotNull.copyProperty(localizacionBien, "piso", dtoAAF.getPlanta());
		beanUtilNotNull.copyProperty(localizacionBien, "puerta", dtoAAF.getPuerta());
		beanUtilNotNull.copyProperty(localizacionBien, "unidadPoblacional",
				utilDiccionarioApi.dameValorDiccionarioByCod(DDUnidadPoblacional.class, dtoAAF.getUnidadMunicipioCodigo()));
		if (!Checks.esNulo(dtoAAF.getMunicipioCodigo())) {
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoAAF.getMunicipioCodigo());
			Localidad localidad = genericDao.get(Localidad.class, f1);
			if (!Checks.esNulo(localidad)) {
				localizacionBien.setLocalidad(localidad);
				beanUtilNotNull.copyProperty(localizacionBien, "provincia",localidad.getProvincia());				
			}
		}
		beanUtilNotNull.copyProperty(localizacionBien, "pais", utilDiccionarioApi.dameValorDiccionarioByCod(DDCicCodigoIsoCirbeBKP.class, "011")); // España.
		beanUtilNotNull.copyProperty(localizacionBien, "codPostal", dtoAAF.getCodigoPostal());
		genericDao.save(NMBLocalizacionesBien.class, localizacionBien);

		// ActivoLocalizacion.
		ActivoLocalizacion activoLocalizacion = new ActivoLocalizacion();
		activoLocalizacion.setActivo(activo);
		activoLocalizacion.setLocalizacionBien(localizacionBien);
		genericDao.save(ActivoLocalizacion.class, activoLocalizacion);

		// PerimetroActivo
		PerimetroActivo perimetroActivo = new PerimetroActivo();
		perimetroActivo.setActivo(activo);
		perimetroActivo.setAplicaGestion(0);
		perimetroActivo.setAplicaComercializar(0);
		perimetroActivo.setAplicaFormalizar(0);
		perimetroActivo.setAplicaPublicar(false);
		perimetroActivo.setIncluidoEnPerimetro(0);
		genericDao.save(PerimetroActivo.class, perimetroActivo);

		// ActivoBancario.
		ActivoBancario activoBancario = new ActivoBancario();
		activoBancario.setActivo(activo);
		beanUtilNotNull.copyProperty(activoBancario, "numExpRiesgo", dtoAAF.getNumPrestamo());
		beanUtilNotNull.copyProperty(activoBancario, "claseActivo",
				utilDiccionarioApi.dameValorDiccionarioByCod(DDClaseActivoBancario.class, DDClaseActivoBancario.CODIGO_FINANCIERO));
		beanUtilNotNull.copyProperty(activoBancario, "estadoExpRiesgo",
				utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoExpRiesgoBancario.class, dtoAAF.getEstadoExpedienteRiesgoCodigo()));
		genericDao.save(ActivoBancario.class, activoBancario);

		// ActivoPlanDinVentas.
		//ActivoAdjudicacionJudicial
		ActivoPlanDinVentas planDinVentas = new ActivoPlanDinVentas();
		planDinVentas.setActivo(activo);
		beanUtilNotNull.copyProperty(planDinVentas, "acreedorNif", dtoAAF.getNifSociedadAcreedora());
		beanUtilNotNull.copyProperty(planDinVentas, "acreedorId", dtoAAF.getCodigoSociedadAcreedora());
		beanUtilNotNull.copyProperty(planDinVentas, "acreedorNombre", dtoAAF.getNombreSociedadAcreedora());
		beanUtilNotNull.copyProperty(planDinVentas, "acreedorDir", dtoAAF.getDireccionSociedadAcreedora());
		beanUtilNotNull.copyProperty(planDinVentas, "importeDeuda", dtoAAF.getImporteDeuda());
		beanUtilNotNull.copyProperty(planDinVentas, "idGarantia", dtoAAF.getIdGarantia());
		genericDao.save(ActivoPlanDinVentas.class, planDinVentas);

		// NMBInformacionRegistralBien.
		NMBInformacionRegistralBien nmbInfRegistralBien = new NMBInformacionRegistralBien();
		nmbInfRegistralBien.setBien(bien);
		if (!Checks.esNulo(dtoAAF.getPoblacionRegistroCodigo())) {
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoAAF.getPoblacionRegistroCodigo());
			Localidad localidad = genericDao.get(Localidad.class, f1);
			if (!Checks.esNulo(localidad)) {
				nmbInfRegistralBien.setLocalidad(localidad);
				nmbInfRegistralBien.setProvincia(localidad.getProvincia());
			}
		}
		beanUtilNotNull.copyProperty(nmbInfRegistralBien, "numRegistro", dtoAAF.getNumRegistro());
		beanUtilNotNull.copyProperty(nmbInfRegistralBien, "tomo", dtoAAF.getTomoRegistro());
		beanUtilNotNull.copyProperty(nmbInfRegistralBien, "libro", dtoAAF.getLibroRegistro());
		beanUtilNotNull.copyProperty(nmbInfRegistralBien, "folio", dtoAAF.getFolioRegistro());
		beanUtilNotNull.copyProperty(nmbInfRegistralBien, "numFinca", dtoAAF.getFincaRegistro());
		beanUtilNotNull.copyProperty(nmbInfRegistralBien, "superficieConstruida", dtoAAF.getSuperficieConstruidaRegistro());

		nmbInfRegistralBien = genericDao.save(NMBInformacionRegistralBien.class, nmbInfRegistralBien);

		// ActivoInfoRegistral.
		ActivoInfoRegistral activoInfoRegistral = new ActivoInfoRegistral();
		activoInfoRegistral.setInfoRegistralBien(nmbInfRegistralBien);
		activoInfoRegistral.setActivo(activo);
		beanUtilNotNull.copyProperty(activoInfoRegistral, "idufir", dtoAAF.getIdufirCruRegistro());
		beanUtilNotNull.copyProperty(activoInfoRegistral, "superficieElementosComunes", dtoAAF.getSuperficieRepercusionEECCRegistro());
		beanUtilNotNull.copyProperty(activoInfoRegistral, "superficieParcela", dtoAAF.getParcelaRegistro());
		beanUtilNotNull.copyProperty(activoInfoRegistral, "superficieUtil", dtoAAF.getSuperficieUtilRegistro());
		if (!Checks.esNulo(dtoAAF.getEsIntegradoDivHorizontalRegistro())) {
			beanUtilNotNull.copyProperty(activoInfoRegistral, "divHorInscrito", dtoAAF.getEsIntegradoDivHorizontalRegistro() ? 1 : 0);
		}
		
		DDSinSiNo noTiene = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo",DDSinSiNo.CODIGO_NO));
		activoInfoRegistral.setTieneAnejosRegistrales(noTiene);
		genericDao.save(ActivoInfoRegistral.class, activoInfoRegistral);

		// ActivoPropietarioActivo.
		List<ActivoPropietario> activoPropietarios = genericDao.getList(ActivoPropietario.class, genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", dtoAAF.getNifPropietario()));
		ActivoPropietario activoPropietario = null;
		if(!Checks.estaVacio(activoPropietarios)) {
			if(activoPropietarios.size() > 1) {
				activoPropietario = genericDao.get(ActivoPropietario.class, genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", dtoAAF.getNifPropietario()), 
						genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", activo.getCartera().getCodigo()));
			}else {
				activoPropietario = activoPropietarios.get(0);
			}
		}
		if(Checks.esNulo(activoPropietario)) {
			// Si el propietario no existe se crea uno nuevo con el NIF recibido.
			activoPropietario = new ActivoPropietario();
			activoPropietario.setDocIdentificativo(dtoAAF.getNifPropietario());
			DDTipoDocumento tipoDocumento = genericDao.get(DDTipoDocumento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "15"));
			activoPropietario.setTipoDocIdentificativo(tipoDocumento);
			activoPropietario.setCartera(activo.getCartera());
			activoPropietario= genericDao.save(ActivoPropietario.class, activoPropietario);
		}
		ActivoPropietarioActivo activoPropietarioActivo = new ActivoPropietarioActivo();
		activoPropietarioActivo.setActivo(activo);
		activoPropietarioActivo.setPropietario(activoPropietario);
		beanUtilNotNull.copyProperty(activoPropietarioActivo, "porcPropiedad", dtoAAF.getPercentParticipacionPropiedad());
		beanUtilNotNull.copyProperty(activoPropietarioActivo, "tipoGradoPropiedad",
				utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoGradoPropiedad.class, dtoAAF.getGradoPropiedadCodigo()));
		genericDao.save(ActivoPropietarioActivo.class, activoPropietarioActivo);

		// ActivoCatastro.
		ActivoCatastro catastro = new ActivoCatastro();
		catastro.setActivo(activo);
		beanUtilNotNull.copyProperty(catastro, "refCatastral", dtoAAF.getReferenciaCatastral());
		genericDao.save(ActivoCatastro.class, catastro);

		// ActivoInfAdministrativa.
		ActivoInfAdministrativa activoInfAdministrativa = new ActivoInfAdministrativa();
		activoInfAdministrativa.setActivo(activo);
		if (!Checks.esNulo(dtoAAF.getEsVPO())) {
			beanUtilNotNull.copyProperty(activoInfAdministrativa, "sueloVpo", dtoAAF.getEsVPO() ? 1 : 0);
		} else {
			beanUtilNotNull.copyProperty(activoInfAdministrativa, "sueloVpo", 0);
		}
		genericDao.save(ActivoInfAdministrativa.class, activoInfAdministrativa);

		// ActivoConfigDocumento - Calificación energética.
		ActivoConfigDocumento configDocumento = new ActivoConfigDocumento();
		beanUtilNotNull.copyProperty(configDocumento, "tipoDocumentoActivo",
				utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumentoActivo.class, DDTipoDocumentoActivo.CODIGO_CEE_ACTIVO));
		configDocumento = genericDao.save(ActivoConfigDocumento.class, configDocumento);

		// ActivoAdmisionDocumento - Calificación energética.
		ActivoAdmisionDocumento admisionDocumento = new ActivoAdmisionDocumento();
		admisionDocumento.setActivo(activo);
		admisionDocumento.setNoValidado(true);
		admisionDocumento.setConfigDocumento(configDocumento);
		beanUtilNotNull.copyProperty(admisionDocumento, "tipoCalificacionEnergetica",
				utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCalificacionEnergetica.class, dtoAAF.getCalificacionCeeCodigo()));
		genericDao.save(ActivoAdmisionDocumento.class, admisionDocumento);

		// ActivoInfoComercial.
		ActivoInfoComercial info = new ActivoInfoComercial();
		info.setActivo(activo);
		info.setTipoActivo(activo.getTipoActivo());			
		if (!Checks.esNulo(dtoAAF.getNifMediador())) {
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", dtoAAF.getNifMediador());
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_MEDIADOR);
			Filter f3 = genericDao.createFilter(FilterType.NULL, "fechaBaja");
			ActivoProveedor mediador = genericDao.get(ActivoProveedor.class, f1,f2, f3);
			if(Checks.esNulo(mediador)){
				f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA);
				mediador = genericDao.get(ActivoProveedor.class, f1, f2, f3);
			}
			info.setMediadorInforme(mediador);
		} else {
			info.setMediadorInforme(this.obtenerMediador(dtoAAF.getNifMediador(),activo.getId()));
		}
		beanUtilNotNull.copyProperty(info, "planta", dtoAAF.getNumPlantasVivienda());
		genericDao.save(ActivoInfoComercial.class, info);
		if(!Checks.esNulo(activo.getTipoActivo()) && DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())){
			ActivoVivienda vivienda = new ActivoVivienda();
			vivienda.setNumPlantasInter(dtoAAF.getNumPlantasVivienda());			
			vivienda.setInformeComercial(info);
			genericDao.save(ActivoVivienda.class, vivienda);
		} else if(!Checks.esNulo(activo.getTipoActivo()) && DDTipoActivo.COD_COMERCIAL.equals(activo.getTipoActivo().getCodigo())){
			ActivoLocalComercial localComercial = new ActivoLocalComercial();
			localComercial.setInformeComercial(info);
			genericDao.save(ActivoLocalComercial.class, localComercial);
		} else if(!Checks.esNulo(activo.getTipoActivo()) && DDTipoActivo.COD_OTROS.equals(activo.getTipoActivo().getCodigo())){
			ActivoPlazaAparcamiento aparcamiento = new ActivoPlazaAparcamiento();
			aparcamiento.setInformeComercial(info);
			genericDao.save(ActivoPlazaAparcamiento.class, aparcamiento);
		}
		else{
			info.setMediadorInforme(this.obtenerMediador(dtoAAF.getNifMediador(),activo.getId()));
			genericDao.save(ActivoInfoComercial.class, info);

		}

		// Baños.
		if (!Checks.esNulo(dtoAAF.getNumBanyosVivienda()) && dtoAAF.getNumBanyosVivienda() > 0) {
			ActivoDistribucion banyo = new ActivoDistribucion();	
			banyo.setInfoComercial(info);
			banyo.setNumPlanta(0);
			banyo.setCantidad(dtoAAF.getNumBanyosVivienda());
			banyo.setTipoHabitaculo((DDTipoHabitaculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoHabitaculo.class, DDTipoHabitaculo.TIPO_HABITACULO_BANYO));
			genericDao.save(ActivoDistribucion.class, banyo);
		}

		// Aseos.
		if (!Checks.esNulo(activo.getTipoActivo()) && !Checks.esNulo(dtoAAF.getNumAseosVivienda()) && dtoAAF.getNumAseosVivienda() > 0) {
			ActivoDistribucion aseos = new ActivoDistribucion();
			aseos.setInfoComercial(info);
			aseos.setNumPlanta(0);
			aseos.setCantidad(dtoAAF.getNumAseosVivienda());
			aseos.setTipoHabitaculo((DDTipoHabitaculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoHabitaculo.class, DDTipoHabitaculo.TIPO_HABITACULO_ASEO));
			genericDao.save(ActivoDistribucion.class, aseos);
		}

		// Dormitorios.
		if (!Checks.esNulo(activo.getTipoActivo()) && !Checks.esNulo(dtoAAF.getNumDormitoriosVivienda()) && dtoAAF.getNumDormitoriosVivienda() > 0) {
			ActivoDistribucion dormitorio = new ActivoDistribucion();
			dormitorio.setInfoComercial(info);			
			dormitorio.setNumPlanta(0);
			dormitorio.setCantidad(dtoAAF.getNumDormitoriosVivienda());
			dormitorio.setTipoHabitaculo((DDTipoHabitaculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoHabitaculo.class, DDTipoHabitaculo.TIPO_HABITACULO_DORMITORIO));
			genericDao.save(ActivoDistribucion.class, dormitorio);
		}

		// Garaje Anejo.
		if (!Checks.esNulo(activo.getTipoActivo()) && !Checks.esNulo(dtoAAF.getGarajeAnejo()) && dtoAAF.getGarajeAnejo()) {
			ActivoDistribucion garajeAnejo = new ActivoDistribucion();
			garajeAnejo.setInfoComercial(info);
			garajeAnejo.setNumPlanta(0);
			garajeAnejo.setCantidad(1);
			garajeAnejo.setTipoHabitaculo((DDTipoHabitaculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoHabitaculo.class, DDTipoHabitaculo.TIPO_HABITACULO_GARAJE));
			genericDao.save(ActivoDistribucion.class, garajeAnejo);
		}
		
		// Trastero Anejo.
		if (!Checks.esNulo(activo.getTipoActivo()) && !Checks.esNulo(dtoAAF.getTrasteroAnejo()) && dtoAAF.getTrasteroAnejo()) {
			ActivoDistribucion trasteroAnejo = new ActivoDistribucion();
			trasteroAnejo.setInfoComercial(info);			
			trasteroAnejo.setNumPlanta(0);
			trasteroAnejo.setCantidad(1);
			trasteroAnejo.setTipoHabitaculo((DDTipoHabitaculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoHabitaculo.class, DDTipoHabitaculo.TIPO_HABITACULO_TRASTERO));
			genericDao.save(ActivoDistribucion.class, trasteroAnejo);
		}

		// ActivoEdificio.
		ActivoEdificio activoEdificio = new ActivoEdificio();
		activoEdificio.setInfoComercial(info);
		genericDao.save(ActivoEdificio.class, activoEdificio);

		// ActivoValoraciones - Precio Mínimo.
		ActivoValoraciones activoValoracionPrecioMinimo = new ActivoValoraciones();
		activoValoracionPrecioMinimo.setFechaCarga(new Date());
		activoValoracionPrecioMinimo.setFechaInicio(new Date());
		activoValoracionPrecioMinimo.setActivo(activo);
		activoValoracionPrecioMinimo.setTipoPrecio((DDTipoPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPrecio.class, DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO));
		beanUtilNotNull.copyProperty(activoValoracionPrecioMinimo, "importe", dtoAAF.getPrecioMinimo());
		activoValoracionPrecioMinimo.setGestor(adapter.getUsuarioLogado());
		genericDao.save(ActivoValoraciones.class, activoValoracionPrecioMinimo);

		// ActivoValoraciones - Precio Venta Web.
		ActivoValoraciones activoValoracionPrecioVentaWeb = new ActivoValoraciones();
		activoValoracionPrecioVentaWeb.setFechaCarga(new Date());
		activoValoracionPrecioVentaWeb.setFechaInicio(new Date());
		activoValoracionPrecioVentaWeb.setActivo(activo);
		activoValoracionPrecioVentaWeb.setTipoPrecio((DDTipoPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPrecio.class, DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA));
		beanUtilNotNull.copyProperty(activoValoracionPrecioVentaWeb, "importe", dtoAAF.getPrecioVentaWeb());
		activoValoracionPrecioVentaWeb.setGestor(adapter.getUsuarioLogado());
		genericDao.save(ActivoValoraciones.class, activoValoracionPrecioVentaWeb);

		// NMBValoracionesBien.
		NMBValoracionesBien bienValoracion = new NMBValoracionesBien();
		bienValoracion.setBien(bien);
		beanUtilNotNull.copyProperty(bienValoracion, "fechaValorTasacion", dtoAAF.getFechaTasacion());
		bienValoracion = genericDao.save(NMBValoracionesBien.class, bienValoracion);

		// ActivoTasacion.
		ActivoTasacion activoTasacion = new ActivoTasacion();
		activoTasacion.setActivo(activo);
		activoTasacion.setValoracionBien(bienValoracion);
		activoTasacion.setCodigoFirma(0L);
		beanUtilNotNull.copyProperty(activoTasacion, "tipoTasacion",
				utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoTasacion.class, DDTipoTasacion.TIPO_ASESORAMIENTO_COMERCIAL));
		beanUtilNotNull.copyProperty(activoTasacion, "importeTasacionFin", dtoAAF.getValorTasacion());
		genericDao.save(ActivoTasacion.class, activoTasacion);

		// PresupuestoActivo.
		int anyo = Calendar.getInstance().get(Calendar.YEAR);
		Filter filterEjercicio = genericDao.createFilter(FilterType.EQUALS, "anyo", String.valueOf(anyo));
		Ejercicio ejercicio = genericDao.get(Ejercicio.class, filterEjercicio);

		PresupuestoActivo presupuestoActivo = new PresupuestoActivo();
		presupuestoActivo.setActivo(activo);
		presupuestoActivo.setImporteInicial(50000d);
		presupuestoActivo.setFechaAsignacion(new Date());
		presupuestoActivo.setEjercicio(ejercicio);
		genericDao.save(PresupuestoActivo.class, presupuestoActivo);

		activo.setBien(bien);
		genericDao.save(Activo.class, activo);
		
		ActivoPublicacion activoPublicacion = new ActivoPublicacion();
		activoPublicacion.setActivo(activo);
		activoPublicacion.setTipoComercializacion((DDTipoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, dtoAAF.getDestinoComercialCodigo()));
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
		activoPublicacion.setVersion(new Long(0));
		
		if (DDTipoComercializacion.CODIGO_VENTA.equals(dtoAAF.getDestinoComercialCodigo())
				|| DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(dtoAAF.getDestinoComercialCodigo())
				|| DDTipoComercializacion.CODIGO_ALQUILER_OPCION_COMPRA.equals(dtoAAF.getDestinoComercialCodigo())) {
			activoPublicacion.setFechaInicioVenta(new Date());
		}
		
		if (DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(dtoAAF.getDestinoComercialCodigo())
				|| DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(dtoAAF.getDestinoComercialCodigo())
				|| DDTipoComercializacion.CODIGO_ALQUILER_OPCION_COMPRA.equals(dtoAAF.getDestinoComercialCodigo())) {
			activoPublicacion.setFechaInicioAlquiler(new Date());
		}
		
		Auditoria auditoria = new Auditoria();
		auditoria.setBorrado(false);
		auditoria.setFechaCrear(new Date());
		auditoria.setUsuarioCrear("ALTA_ACTIVOS_FINANCIEROS");
		activoPublicacion.setAuditoria(auditoria);
		
		genericDao.save(ActivoPublicacion.class, activoPublicacion);
		
		ActivoPublicacionHistorico activoPublicacionHistorico = new ActivoPublicacionHistorico();
		BeanUtils.copyProperties(activoPublicacionHistorico, activoPublicacion);
		genericDao.save(ActivoPublicacionHistorico.class, activoPublicacionHistorico);
	}
	
	private ActivoProveedor obtenerMediador(String nifMediador,Long idActivo){
		ActivoProveedor mediador = null;
		mediador = gestorActivoManager.obtenerProveedorTecnico(idActivo);
		if (!Checks.esNulo(nifMediador) && Checks.esNulo(mediador)) {
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", nifMediador);
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_MEDIADOR);
			Filter f3 = genericDao.createFilter(FilterType.NULL, "fechaBaja");
			mediador = genericDao.get(ActivoProveedor.class, f1,f2, f3);
			
			if(Checks.esNulo(mediador)){
				f2 = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA);
				mediador = genericDao.get(ActivoProveedor.class, f1, f2);
			}
		}
		
		return mediador;
	}
	private void guardarDatosPatrimonioActivo(DtoAltaActivoFinanciero dtoAAF, Activo activo) throws Exception {
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