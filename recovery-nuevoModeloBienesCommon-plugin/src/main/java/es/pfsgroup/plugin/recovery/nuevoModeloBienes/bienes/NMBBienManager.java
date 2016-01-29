package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.hibernate.proxy.HibernateProxy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.devon.web.DynamicElementManager;
import es.capgemini.pfs.asunto.dao.EXTAsuntoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.dto.DtoBien;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.DDSolvenciaGarantia;
import es.capgemini.pfs.bien.model.DDTipoBien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.dao.EXTPersonaDao;
import es.capgemini.pfs.persona.model.EXTPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.DDPostores2;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastasServicioTasacionDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.adjudicacion.dto.DtoNMBBienAdjudicacion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.dao.NMBBienDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionPosesoria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTasadora;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoImposicion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoInmueble;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoProdBancario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoTributacion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDimpuestoCompra;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdicionalBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDEstadoBienContrato;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDOrigenBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDTipoBienContrato;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDtipoSubasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBEmbargoProcedimiento;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBPersonasBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBSubastaInstrucciones;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.Dto.BienProcedimientoDTO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.Dto.DtoSubastaInstrucciones;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.BienApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.ProcedimientoApi;
import es.pfsgroup.recovery.ext.api.procedimiento.EXTProcedimientoApi;

@Service("nmbBienManager")
public class NMBBienManager extends BusinessOperationOverrider<BienApi> implements BienApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
	protected static final Log logger = LogFactory.getLog(NMBBienManager.class);
	
	@Autowired
	private Executor executor;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private NMBBienDao nmbBienDao;

	@Autowired
	private EXTPersonaDao personaDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private EXTAsuntoDao extAsuntoDao;

	@Override
	public String managerName() {
		return "bienManager";
	}

	@Autowired
	private FuncionManager funcionManager;

	@Autowired
	DynamicElementManager tabManager;

	@BusinessOperation("NMBbienManager.getTabs")
	public List<DynamicElement> getTabs(long idBien) {
		return tabManager.getDynamicElements("bien.tabs", idBien);
	}

	@BusinessOperation("NMBbienManager.getButtons")
	public List<DynamicElement> getButtons(long idBien) {
		return tabManager.getDynamicElements("bien.buttons", idBien);
	}

	@Override
	@BusinessOperation(overrides = PrimariaBusinessOperation.BO_BIEN_MGR_GET)
	public Bien get(Long id) {
		Bien b = parent().get(id);
		try {
			NMBBien bien = new NMBBien();
			bien = getNMBBien(b);
			return bien;
		} catch (Exception e) {
			return b;
		}
	}
	
	@BusinessOperation(GET_BIEN_BY_ID)
	public Bien getBienById(Long id) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id",id);
		Bien b = genericDao.get(Bien.class, f1);
		try {
			NMBBien bien = new NMBBien();
			bien = getNMBBien(b);
			return bien;
		} catch (Exception e) {
			return b;
		}
	}

	private NMBBien getNMBBien(Bien b) {
		NMBBien bien;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", b.getId());
		bien = genericDao.get(NMBBien.class, f1);
		return bien;
	}

	/**
	 * M�todo para buscar los contratos que tiene asociado un bien.
	 */
	@BusinessOperation("plugin.nuevoModeloBienes.bienes.NMBbienManager.getContratos")
	public List<NMBContratoBien> getContratos(Long idBien) {
		List<NMBContratoBien> listNMBContratoBien = new ArrayList<NMBContratoBien>();
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "bien.id", idBien);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter f3 = genericDao.createFilter(FilterType.EQUALS, "contrato.auditoria.borrado", false);
		listNMBContratoBien.addAll(genericDao.getList(NMBContratoBien.class, f1, f2, f3));
		return listNMBContratoBien;
	}

	/**
	 * M�todo para buscar las personas relacionadas con un bien.
	 */
	@BusinessOperation("plugin.nuevoModeloBienes.bienes.NMBbienManager.getPersonas")
	public List<NMBPersonasBien> getPersonas(Long idBien) {
		List<NMBPersonasBien> listNMBPersonasBien = new ArrayList<NMBPersonasBien>();
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "bien.id", idBien);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter f3 = genericDao.createFilter(FilterType.EQUALS, "persona.auditoria.borrado", false);
		listNMBPersonasBien.addAll(genericDao.getList(NMBPersonasBien.class, f1, f2, f3));
		return listNMBPersonasBien;
	}

	/**
	 * M�todo para buscar los embargos registrados para un bien
	 */
	@BusinessOperation("plugin.nuevoModeloBienes.bienes.NMBbienManager.getEmbargos")
	public List<NMBEmbargoProcedimiento> getEmbargos(Long idBien) {
		/*
		 * List<EmbargoProcedimiento> listEmbargoProcedimiento = new
		 * ArrayList<EmbargoProcedimiento>(); Filter f1 =
		 * genericDao.createFilter(FilterType.EQUALS, "bien.id", idBien); Filter
		 * f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado",
		 * false);
		 * listEmbargoProcedimiento.addAll(genericDao.getList(EmbargoProcedimiento
		 * .class, f1, f2)); return listEmbargoProcedimiento;
		 */

		List<NMBEmbargoProcedimiento> listEmbargoProcedimiento = new ArrayList<NMBEmbargoProcedimiento>();
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "bien.id", idBien);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		listEmbargoProcedimiento.addAll(genericDao.getList(NMBEmbargoProcedimiento.class, f1, f2));
		return listEmbargoProcedimiento;
	}

	/**
	 * M�todo para buscar bienes seg�n filtros indicados en el DTO.
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation("plugin.nuevoModeloBienes.bienes.NMBbienManager.buscarBienes")
	@Transactional
	public Page buscarBienes(NMBDtoBuscarBienes dto) {
		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		List<NMBBien> listaRetorno = new ArrayList<NMBBien>();
		PageHibernate page = (PageHibernate) nmbBienDao.buscarBienesPaginados(dto, usuarioLogado);
		if (page != null) {
			listaRetorno.addAll((List<NMBBien>) page.getResults());
			page.setResults(listaRetorno);
		}
		return page;
	}

	/**
	 * M�todo para buscar bienes seg�n filtros indicados en el DTO para EXCEL.
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation("plugin.nuevoModeloBienes.bienes.NMBbienManager.buscarBienesXLS")
	@Transactional
	public List<NMBBien> buscarBienesXLS(NMBDtoBuscarBienes dto) {
		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		dto.setLimit(2000);
		List<NMBBien> listaRetorno = new ArrayList<NMBBien>();
		PageHibernate page = (PageHibernate) nmbBienDao.buscarBienesPaginados(dto, usuarioLogado);
		listaRetorno.addAll((List<NMBBien>) page.getResults());
		page.setResults(listaRetorno);
		return (List<NMBBien>) page.getResults();
	}

	/**
	 * Nuevo m�todo para gestionar bienes.
	 * 
	 * @return
	 */
	@BusinessOperation("NMBbienManager.createOrUpdateNMB")
	@Transactional(readOnly = false)
	public NMBBien createOrUpdateNMB(DtoNMBBien dtoBien, Long idPersona) {
		Long idBien;
		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);

		if (dtoBien.getId() == null) { // nuevo
			// crear nuevo bien
			NMBBien nmbBien = new NMBBien();
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "descripcion", "Manual");
			NMBDDOrigenBien origen = genericDao.get(NMBDDOrigenBien.class, f1);
			nmbBien.setOrigen(origen);
			genericDao.save(NMBBien.class, nmbBien);
			idBien = nmbBien.getId();
		} else {
			idBien = dtoBien.getId();
		}

		NMBBien bien;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", idBien);
		bien = genericDao.get(NMBBien.class, f1);

		f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getTipoBien());
		DDTipoBien tipoBien = genericDao.get(DDTipoBien.class, f1);
		bien.setTipoBien(tipoBien);
		bien.setParticipacion(dtoBien.getParticipacion());

	    bien.setValorActual(dtoBien.getValorActual());
	    bien.setImporteCargas(dtoBien.getImporteCargas());
	    bien.setDescripcionBien(dtoBien.getDescripcionBien());
	    bien.setSolvenciaNoEncontrada(dtoBien.isSolvenciaNoEncontrada());
	    bien.setObraEnCurso(dtoBien.isObraEnCurso());
	    bien.setDueDilligence(dtoBien.isDueDilligence());
	    try {
			bien.setFechaVerificacion(DateFormat.toDate(dtoBien.getFechaVerificacion()));
			bien.setFechaDueD(DateFormat.toDate(dtoBien.getFechaDueD()));
			bien.setFechaSolicitudDueD(DateFormat.toDate(dtoBien.getFechaSolicitudDueD()));
		} catch (ParseException e) {
			e.printStackTrace();
		}

		bien.setViviendaHabitual(dtoBien.getViviendaHabitual());
		bien.setTipoSubasta(dtoBien.getTipoSubasta());
		bien.setNumeroActivo(dtoBien.getNumeroActivo());
		bien.setLicenciaPrimeraOcupacion(dtoBien.getLicenciaPrimeraOcupacion());
		bien.setTransmitentePromotor(dtoBien.getTransmitentePromotor());
		bien.setArrendadoSinOpcCompra(dtoBien.getArrendadoSinOpcCompra());
		bien.setUsoPromotorMayorDosAnyos(dtoBien.getUsoPromotorMayorDosAnyos());
		bien.setPrimeraTransmision(dtoBien.getPrimeraTransmision());
		bien.setContratoAlquiler(dtoBien.getContratoAlquiler());
		if (dtoBien.getSituacionPosesoria() != null) {
			Filter filtroSituacionPosesoria = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getSituacionPosesoria());
			DDSituacionPosesoria situacionPosesoria = genericDao.get(DDSituacionPosesoria.class, filtroSituacionPosesoria);
			bien.setSituacionPosesoria(situacionPosesoria);
		}

		bien.setDatosRegistrales(dtoBien.getDatosRegistrales());

		if (dtoBien.getTributacion() != null) {
			Filter filtroTributacion = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getTributacion());
			DDTipoTributacion tipoTributacion = genericDao.get(DDTipoTributacion.class, filtroTributacion);
			bien.setTributacion(tipoTributacion);
		}
		if (dtoBien.getTributacionVenta() != null) {
			Filter filtroTributacionVenta = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getTributacionVenta());
			DDTipoTributacion tipoTributacionVenta = genericDao.get(DDTipoTributacion.class, filtroTributacionVenta);
			bien.setTributacionVenta(tipoTributacionVenta);
		}
		if (dtoBien.getTipoImposicionCompra() != null) {
			Filter filtroImposicion = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getTipoImposicionCompra());
			DDTipoImposicion tipoImposicion = genericDao.get(DDTipoImposicion.class, filtroImposicion);
			bien.setTipoImposicionCompra(tipoImposicion);
		}
		if (dtoBien.getTipoImposicionVenta() != null) {
			Filter filtroImposicionVenta = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getTipoImposicionVenta());
			DDTipoImposicion tipoImposicionVenta = genericDao.get(DDTipoImposicion.class, filtroImposicionVenta);
			bien.setTipoImposicionVenta(tipoImposicionVenta);
		}
		if (dtoBien.getInversionPorRenuncia() != null) {
			Filter filtroInversion = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getInversionPorRenuncia());
			DDSiNo tipoImposicion = genericDao.get(DDSiNo.class, filtroInversion);
			bien.setInversionPorRenuncia(tipoImposicion);
		}
		

		if (funcionManager.tieneFuncion(usuarioLogado, "ESTRUCTURA_COMPLETA_BIENES")) {
			// cargar valores del nuevo formulario
			bien.setReferenciaCatastral(dtoBien.getReferenciaCatastralBien());
			bien.setSuperficie(dtoBien.getSuperficie());
			bien.setPoblacion(dtoBien.getPoblacion());
		} else {
			// cargar valores del viejo formulario
			bien.setReferenciaCatastral(dtoBien.getReferenciaCatastral());
			bien.setSuperficie(dtoBien.getBieSuperficie());
			bien.setPoblacion(dtoBien.getBiePoblacion());
		}

		bien.setObservaciones(dtoBien.getObservaciones());

		// setear el bien tal y como se hacia con el formato antiguo.
		DtoBien dtoBienOriginal = new DtoBien();
		dtoBienOriginal.setBien(bien);
		executor.execute(PrimariaBusinessOperation.BO_BIEN_MGR_CREATE_OR_UPDATE, dtoBienOriginal, idPersona);
		
		bien.setPorcentajeImpuestoCompra(dtoBien.getPorcentajeImpuestoCompra());
		
		if (dtoBien.getImpuestoCompra() != null) {
			Filter filterImpuesto = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getImpuestoCompra());
			DDimpuestoCompra impuestoCompra = genericDao.get(DDimpuestoCompra.class, filterImpuesto);
			bien.setImpuestoCompra(impuestoCompra);
		}
		
		

		genericDao.update(NMBBien.class, bien);
		/* relacion bien - persona */
		if (idPersona != null) {
			NMBPersonasBien nmbPersonasBien = null;
			f1 = genericDao.createFilter(FilterType.EQUALS, "persona.id", idPersona);
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "bien.id", idBien);
			nmbPersonasBien = genericDao.get(NMBPersonasBien.class, f1, f2);
			if (nmbPersonasBien == null) {
				// crear nueva relaci�n bien - persona
				Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
				nmbPersonasBien = new NMBPersonasBien();
				nmbPersonasBien.setPersona(persona);
				nmbPersonasBien.setBien(bien);
				if (dtoBien.getParticipacionNMB() != null) {
					nmbPersonasBien.setParticipacion(dtoBien.getParticipacionNMB());
				}
				genericDao.save(NMBPersonasBien.class, nmbPersonasBien);
			}
			if (dtoBien.getParticipacion() != null)
				nmbPersonasBien.setParticipacion((float) (dtoBien.getParticipacion()));
			genericDao.save(NMBPersonasBien.class, nmbPersonasBien);
		}
		/* guardar nuevos campos del NMBBien solo si el usuario tiene permiso */

		if (funcionManager.tieneFuncion(usuarioLogado, "ESTRUCTURA_COMPLETA_BIENES")) {

			/* localizaciones */
			NMBLocalizacionesBien nmbLocalizacion;
			if (bien.getLocalizacionActual() == null) {
				nmbLocalizacion = new NMBLocalizacionesBien();
				nmbLocalizacion.setBien(bien);
			} else {
				f1 = genericDao.createFilter(FilterType.EQUALS, "bien.id", bien.getId());
				nmbLocalizacion = genericDao.get(NMBLocalizacionesBien.class, f1);
			}
			nmbLocalizacion.setCodPostal(dtoBien.getCodPostal());
			nmbLocalizacion.setDireccion(dtoBien.getDireccion());
			nmbLocalizacion.setPoblacion(dtoBien.getPoblacion());
			nmbLocalizacion.setNombreVia(dtoBien.getNombreVia());
			nmbLocalizacion.setNumeroDomicilio(dtoBien.getNumeroDomicilio());
			nmbLocalizacion.setPortal(dtoBien.getPortal());
			nmbLocalizacion.setBloque(dtoBien.getBloque());
			nmbLocalizacion.setEscalera(dtoBien.getEscalera());
			nmbLocalizacion.setPiso(dtoBien.getPiso());
			nmbLocalizacion.setPuerta(dtoBien.getPuerta());
			nmbLocalizacion.setBarrio(dtoBien.getBarrio());
			
			
			if (!Checks.esNulo(dtoBien.getProvincia())) {
				f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getProvincia());
				DDProvincia provincia = genericDao.get(DDProvincia.class, f1);
				nmbLocalizacion.setProvincia(provincia);
			}
			else{
				nmbLocalizacion.setProvincia(null);
			}
			
			if (!Checks.esNulo(dtoBien.getLocalidad())) {
				f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getLocalidad());
				Localidad localidad = genericDao.get(Localidad.class, f1);
				nmbLocalizacion.setLocalidad(localidad);
			}
			else{
				nmbLocalizacion.setLocalidad(null);
			}
			
			if (!Checks.esNulo(dtoBien.getUnidadPoblacional())) {
				f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getUnidadPoblacional());
				DDUnidadPoblacional unidadPoblacional = genericDao.get(DDUnidadPoblacional.class, f1);
				nmbLocalizacion.setUnidadPoblacional(unidadPoblacional);
			}
			else{
				nmbLocalizacion.setUnidadPoblacional(null);
			}
			
			if (!Checks.esNulo(dtoBien.getTipoVia())) {
				f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getTipoVia());
				DDTipoVia ddTipoVia = genericDao.get(DDTipoVia.class, f1);
				nmbLocalizacion.setTipoVia(ddTipoVia);
			}
			else{
				nmbLocalizacion.setTipoVia(null);
			}
			
			if (!Checks.esNulo(dtoBien.getPais())) {
				f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getPais());
				DDCicCodigoIsoCirbeBKP pais = genericDao.get(DDCicCodigoIsoCirbeBKP.class, f1);
				nmbLocalizacion.setPais(pais);
			}
			else{
				nmbLocalizacion.setPais(null);
			}
			
			genericDao.save(NMBLocalizacionesBien.class, nmbLocalizacion);
			

			/* datos registrales */
			NMBInformacionRegistralBien nmbInformacionRegistralBien;
			if (bien.getDatosRegistralesActivo() == null) {
				nmbInformacionRegistralBien = new NMBInformacionRegistralBien();
				nmbInformacionRegistralBien.setBien(bien);
			} else {
				f1 = genericDao.createFilter(FilterType.EQUALS, "bien.id", bien.getId());
				nmbInformacionRegistralBien = genericDao.get(NMBInformacionRegistralBien.class, f1);
			}
			nmbInformacionRegistralBien.setNumFinca(dtoBien.getNumFinca());
			nmbInformacionRegistralBien.setReferenciaCatastralBien(dtoBien.getReferenciaCatastralBien());
			nmbInformacionRegistralBien.setTomo(dtoBien.getTomo());
			nmbInformacionRegistralBien.setLibro(dtoBien.getLibro());
			nmbInformacionRegistralBien.setFolio(dtoBien.getFolio());
			nmbInformacionRegistralBien.setInscripcion(dtoBien.getInscripcion());
			if (dtoBien.getFechaInscripcion() != null)
				try {
					nmbInformacionRegistralBien.setFechaInscripcion(DateFormat.toDate(dtoBien.getFechaInscripcion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			else
				nmbInformacionRegistralBien.setFechaInscripcion(null);
			nmbInformacionRegistralBien.setNumRegistro(dtoBien.getNumRegistro());
			nmbInformacionRegistralBien.setMunicipoLibro(dtoBien.getMunicipoLibro());
			nmbInformacionRegistralBien.setCodigoRegistro(dtoBien.getCodigoRegistro());
			nmbInformacionRegistralBien.setSuperficieConstruida(dtoBien.getSuperficieConstruida());
			nmbInformacionRegistralBien.setSuperficie(dtoBien.getSuperficie());
			
			if (!Checks.esNulo(dtoBien.getProvinciaRegistro())) {
				f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getProvinciaRegistro());
				DDProvincia provincia = genericDao.get(DDProvincia.class, f1);
				nmbInformacionRegistralBien.setProvincia(provincia);
			}
			else{
				nmbInformacionRegistralBien.setProvincia(null);
			}
			
			if (!Checks.esNulo(dtoBien.getMunicipioRegistro())) {
				f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getMunicipioRegistro());
				Localidad localidad = genericDao.get(Localidad.class, f1);
				nmbInformacionRegistralBien.setLocalidad(localidad);
			}
			else{
				nmbInformacionRegistralBien.setLocalidad(null);
			}
			
			genericDao.save(NMBInformacionRegistralBien.class, nmbInformacionRegistralBien);

			/* Datos adicionales */
			NMBAdicionalBien nmbAdicionalBien;
			// Comprobar que no existe;
			f1 = genericDao.createFilter(FilterType.EQUALS, "bien.id", bien.getId());
			nmbAdicionalBien = genericDao.get(NMBAdicionalBien.class, f1);
			if (Checks.esNulo(nmbAdicionalBien)) {
				nmbAdicionalBien = new NMBAdicionalBien();
				nmbAdicionalBien.setBien(bien);
			}

			nmbAdicionalBien.setNomEmpresa(dtoBien.getNomEmpresa());
			nmbAdicionalBien.setCifEmpresa(dtoBien.getCifEmpresa());
			nmbAdicionalBien.setCodIAE(dtoBien.getCodIAE());
			nmbAdicionalBien.setDesIAE(dtoBien.getDesIAE());

			if (!Checks.esNulo(dtoBien.getTipoProdBancario())) {
				f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getTipoProdBancario());
				DDTipoProdBancario tipoProdBancario = genericDao.get(DDTipoProdBancario.class, f1);
				nmbAdicionalBien.setTipoProdBancario(tipoProdBancario);
			}
			else{
				nmbAdicionalBien.setTipoProdBancario(null);
			}

			if (!Checks.esNulo(dtoBien.getTipoInmueble())) {
				f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getTipoInmueble());
				DDTipoInmueble tipoInmueble = genericDao.get(DDTipoInmueble.class, f1);
				nmbAdicionalBien.setTipoInmueble(tipoInmueble);
			}
			else{
				nmbAdicionalBien.setTipoInmueble(null);
			}

			nmbAdicionalBien.setValoracion(dtoBien.getValoracion());
			nmbAdicionalBien.setEntidad(dtoBien.getEntidad());
			nmbAdicionalBien.setNumCuenta(dtoBien.getNumCuenta());
			nmbAdicionalBien.setMatricula(dtoBien.getMatricula());
			nmbAdicionalBien.setBastidor(dtoBien.getBastidor());
			nmbAdicionalBien.setModelo(dtoBien.getModelo());
			nmbAdicionalBien.setMarca(dtoBien.getMarca());
			if (!Checks.esNulo(dtoBien.getFechaMatricula())) {
				try {
					nmbAdicionalBien.setFechaMatricula(DateFormat.toDate(dtoBien.getFechaMatricula()));
				} catch (ParseException e) {
					logger.error("createOrUpdateNMB: "+e);
				}
			}
			genericDao.save(NMBAdicionalBien.class, nmbAdicionalBien);

			/* valoraciones */
			NMBValoracionesBien nmbValoracionesBien;
			if (bien.getValoracionActiva() == null) {
				nmbValoracionesBien = new NMBValoracionesBien();
				nmbValoracionesBien.setBien(bien);
			} else {
				f1 = genericDao.createFilter(FilterType.EQUALS, "bien.id", bien.getId());
				nmbValoracionesBien = genericDao.get(NMBValoracionesBien.class, f1);
			}
			if (dtoBien.getFechaValorApreciacion() != null)
				try {
					nmbValoracionesBien.setFechaValorApreciacion(DateFormat.toDate(dtoBien.getFechaValorApreciacion()));
				} catch (ParseException e) {
					logger.error("createOrUpdateNMB fechaValorApreciacion: "+e);
				}
			else
				nmbValoracionesBien.setFechaValorApreciacion(null);
			if (dtoBien.getFechaValorSubjetivo() != null)
				try {
					nmbValoracionesBien.setFechaValorSubjetivo(DateFormat.toDate(dtoBien.getFechaValorSubjetivo()));
				} catch (ParseException e) {
					logger.error("createOrUpdateNMB fechaValorSubjetivo: "+e);
				}
			else
				nmbValoracionesBien.setFechaValorSubjetivo(null);
			if (dtoBien.getFechaValorTasacion() != null)
				try {
					nmbValoracionesBien.setFechaValorTasacion(DateFormat.toDate(dtoBien.getFechaValorTasacion()));
				} catch (ParseException e) {
					logger.error("createOrUpdateNMB fechaValorTasacion: "+e);
				}
			else
				nmbValoracionesBien.setFechaValorTasacion(null);

			nmbValoracionesBien.setRespuestaConsulta(dtoBien.getRespuestaConsulta());
			nmbValoracionesBien.setValorTasacionExterna(dtoBien.getValorTasacionExterna());
			if (dtoBien.getTasadora() != null) {
				Filter filtroTasadora = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoBien.getTasadora());
				DDTasadora tasadora = genericDao.get(DDTasadora.class, filtroTasadora);
				nmbValoracionesBien.setTasadora(tasadora);
			}
			if (dtoBien.getFechaTasacionExterna() != null) {
				try {
					nmbValoracionesBien.setFechaTasacionExterna(ft.parse(dtoBien.getFechaTasacionExterna()));
				} catch (ParseException e) {
					logger.error("createOrUpdateNMB fechaTasacionExterna: "+e);
				}
			}
			if (dtoBien.getFechaSolicitudTasacion() != null) {
				try {
					nmbValoracionesBien.setFechaSolicitudTasacion(ft.parse(dtoBien.getFechaSolicitudTasacion()));
				} catch (ParseException e) {
					logger.error("createOrUpdateNMB fechaSolicitudTasacion: "+e);
				}
			}

			nmbValoracionesBien.setImporteValorApreciacion(dtoBien.getImporteValorApreciacion());
			nmbValoracionesBien.setImporteValorSubjetivo(dtoBien.getImporteValorSubjetivo());
			nmbValoracionesBien.setImporteValorTasacion(dtoBien.getImporteValorTasacion());
			genericDao.save(NMBValoracionesBien.class, nmbValoracionesBien);
		} else {
			// miramos de setear las propiedades que se repiten en NMBBien
			// ref catastral & superficie
			NMBInformacionRegistralBien nmbInformacionRegistralBien;
			if (bien.getDatosRegistralesActivo() == null) {
				nmbInformacionRegistralBien = new NMBInformacionRegistralBien();
				nmbInformacionRegistralBien.setBien(bien);
			} else {
				f1 = genericDao.createFilter(FilterType.EQUALS, "bien.id", bien.getId());
				nmbInformacionRegistralBien = genericDao.get(NMBInformacionRegistralBien.class, f1);
			}
			nmbInformacionRegistralBien.setReferenciaCatastralBien(dtoBien.getReferenciaCatastral());
			nmbInformacionRegistralBien.setSuperficie(dtoBien.getBieSuperficie());
			genericDao.save(NMBInformacionRegistralBien.class, nmbInformacionRegistralBien);
			// poblacion
			NMBLocalizacionesBien nmbLocalizacion;
			if (bien.getLocalizacionActual() == null) {
				nmbLocalizacion = new NMBLocalizacionesBien();
				nmbLocalizacion.setBien(bien);
			} else {
				f1 = genericDao.createFilter(FilterType.EQUALS, "bien.id", bien.getId());
				nmbLocalizacion = genericDao.get(NMBLocalizacionesBien.class, f1);
			}
			nmbLocalizacion.setPoblacion(dtoBien.getBiePoblacion());
			genericDao.save(NMBLocalizacionesBien.class, nmbLocalizacion);
		}

		return bien;
	}

	@Override
	@BusinessOperation("plugin.nuevoModeloBienes.clientes.NMBbienManager.marcarBienAutomatico")
	@Transactional(readOnly = false)
	public void marcarBienAutomatico(Long idBien) {
		NMBBien bien;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", idBien);
		bien = genericDao.get(NMBBien.class, f1);
		if (bien.getMarcaExternos().equals(1))
			bien.setMarcaExternos(0);
		else
			bien.setMarcaExternos(1);
	}

	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation("NMBbienManager.getClientesPaginados")
	public Page getClientesPaginados(NMBDtoBuscarClientes dto) {
		List<Persona> listaRetorno = new ArrayList<Persona>();
		PageHibernate page = (PageHibernate) nmbBienDao.buscarClientesPaginados(dto);
		if (page != null) {
			listaRetorno.addAll((List<Persona>) page.getResults());
			page.setResults(listaRetorno);
		}
		return page;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation("NMBbienManager.getContratosPaginados")
	public Page getContratosPaginados(BusquedaContratosDto dto) {
		List<Contrato> listaRetorno = new ArrayList<Contrato>();
		PageHibernate page = (PageHibernate) nmbBienDao.buscarContratosPaginados(dto);
		if (page != null) {
			listaRetorno.addAll((List<Contrato>) page.getResults());
			page.setResults(listaRetorno);
		}
		return page;
	}	

	@Override
	@BusinessOperation("NMBbienManager.saveParticipacionNMB")
	@Transactional(readOnly = false)
	public void saveParticipacionNMB(float participacion, Long idBien, Long idPersona) {
		if (idPersona != null && idBien != null) {
			NMBPersonasBien nmbPersonasBien = null;
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "persona.id", idPersona);
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "bien.id", idBien);
			nmbPersonasBien = genericDao.get(NMBPersonasBien.class, f1, f2);
			if (nmbPersonasBien == null) {
				// crear nueva relaci�n bien - persona
				Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
				NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(idBien);
				nmbPersonasBien = new NMBPersonasBien();
				nmbPersonasBien.setPersona(persona);
				nmbPersonasBien.setBien(bien);
			} else
				nmbPersonasBien.setBorrado(false);
			nmbPersonasBien.setParticipacion(participacion);
			genericDao.save(NMBPersonasBien.class, nmbPersonasBien);
		}
	}

	@Override
	@BusinessOperation("NMBbienManager.saveBienContrato")
	@Transactional(readOnly = false)
	public void saveBienContrato(Long idContrato, Long idBien, String codTipoBienContrato) {
		if (idContrato != null && idBien != null) {
			Contrato contrato = null;
			NMBDDTipoBienContrato tipoBienContrato = (NMBDDTipoBienContrato) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(NMBDDTipoBienContrato.class,codTipoBienContrato);
			NMBDDEstadoBienContrato estadoBienContrato = (NMBDDEstadoBienContrato) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(NMBDDEstadoBienContrato.class,NMBDDEstadoBienContrato.COD_ESTADO_BIEN_ACTIVO);
			
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", idContrato);
			contrato = genericDao.get(Contrato.class, f1);
			NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(idBien);
			List<NMBContratoBien> contratos = bien.getContratos();
			if (contratos == null) {
				contratos = new ArrayList<NMBContratoBien>();
			}
			Boolean edicion = false;
			for(NMBContratoBien c : contratos) {
				//es edicion??
				if(idContrato.compareTo(c.getContrato().getId()) == 0 ){
					c.setTipo(tipoBienContrato);
					edicion = true;
					genericDao.update(NMBContratoBien.class, c);
				}
			}
			if (contrato != null && !edicion) {
				
				NMBContratoBien contratoBien = new NMBContratoBien();
				contratoBien.setBien(bien);
				contratoBien.setContrato(contrato);
				contratoBien.setImporteGarantizado(contrato.getRiesgo());
				contratoBien.setTipo(tipoBienContrato);
				contratoBien.setEstado(estadoBienContrato);
				Auditoria auditoria = new Auditoria();
				Date date = new Date();
				auditoria.setFechaCrear(date);
				auditoria.setUsuarioCrear("WEB");
				auditoria.setBorrado(false);
				contratoBien.setAuditoria(auditoria);
				contratos.add(contratoBien);
				bien.setContratos(contratos);
				genericDao.update(NMBBien.class, bien);
			}
		}
	}

	@Override
	@BusinessOperation("NMBbienManager.saveInstruccionesNMB")
	@Transactional(readOnly = false)
	public void saveInstruccionesNMB(DtoSubastaInstrucciones dtoInstrucciones) {
		if (dtoInstrucciones != null && dtoInstrucciones.getIdBien() != null && dtoInstrucciones.getIdProcedimiento() != null) {

			Long idInstrucciones;
			Filter f1 = null;

			if (dtoInstrucciones.getIdInstrucciones() == null) { // nuevo
				// crear nuevas instrucciones
				NMBSubastaInstrucciones subastaInstrucciones = new NMBSubastaInstrucciones();
				NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(dtoInstrucciones.getIdBien());
				subastaInstrucciones.setBien(bien);
				Procedimiento procedimiento = (Procedimiento) proxyFactory.proxy(es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi.class)
						.getProcedimiento(dtoInstrucciones.getIdProcedimiento());
				subastaInstrucciones.setProcedimiento(procedimiento);
				if (dtoInstrucciones.getCodigoTipoSubasta() != null) {
					f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoInstrucciones.getCodigoTipoSubasta());
				} else {
					f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", NMBDDtipoSubasta.APREMIO);
				}
				NMBDDtipoSubasta tipoSubasta = genericDao.get(NMBDDtipoSubasta.class, f1);
				subastaInstrucciones.setTipoSubasta(tipoSubasta);
				genericDao.save(NMBSubastaInstrucciones.class, subastaInstrucciones);
				idInstrucciones = subastaInstrucciones.getId();
			} else {
				idInstrucciones = dtoInstrucciones.getIdInstrucciones();
			}

			NMBSubastaInstrucciones nmbSubastaInstrucciones;
			f1 = genericDao.createFilter(FilterType.EQUALS, "id", idInstrucciones);
			nmbSubastaInstrucciones = genericDao.get(NMBSubastaInstrucciones.class, f1);

			nmbSubastaInstrucciones.setCargasAnteriores(dtoInstrucciones.getCargasAnteriores());
			nmbSubastaInstrucciones.setFechaInscripcion(dtoInstrucciones.getFechaInscripcion());
			nmbSubastaInstrucciones.setFechaLlaves(dtoInstrucciones.getFechaLlaves());
			nmbSubastaInstrucciones.setImporteSegundaSubasta(dtoInstrucciones.getImporteSegundaSubasta());
			nmbSubastaInstrucciones.setImporteTerceraSubasta(dtoInstrucciones.getImporteTerceraSubasta());
			nmbSubastaInstrucciones.setPeritacionActual(dtoInstrucciones.getPeritacionActual());
			nmbSubastaInstrucciones.setPrimeraSubasta(dtoInstrucciones.getPrimeraSubasta());
			nmbSubastaInstrucciones.setPrincipal(dtoInstrucciones.getPrincipal());
			nmbSubastaInstrucciones.setPropuestaCapital(dtoInstrucciones.getPropuestaCapital());
			nmbSubastaInstrucciones.setPropuestaCostas(dtoInstrucciones.getPropuestaCostas());
			nmbSubastaInstrucciones.setPropuestaDemoras(dtoInstrucciones.getPropuestaDemoras());
			nmbSubastaInstrucciones.setPropuestaIntereses(dtoInstrucciones.getPropuestaIntereses());
			nmbSubastaInstrucciones.setResponsabilidadCapital(dtoInstrucciones.getResponsabilidadCapital());
			nmbSubastaInstrucciones.setResponsabilidadCostas(dtoInstrucciones.getResponsabilidadCostas());
			nmbSubastaInstrucciones.setResponsabilidadDemoras(dtoInstrucciones.getResponsabilidadDemoras());
			nmbSubastaInstrucciones.setResponsabilidadIntereses(dtoInstrucciones.getResponsabilidadIntereses());
			nmbSubastaInstrucciones.setSegundaSubasta(dtoInstrucciones.getSegundaSubasta());
			nmbSubastaInstrucciones.setTerceraSubasta(dtoInstrucciones.getTerceraSubasta());
			nmbSubastaInstrucciones.setTipoSegundaSubasta(dtoInstrucciones.getTipoSegundaSubasta());
			nmbSubastaInstrucciones.setTipoTerceraSubasta(dtoInstrucciones.getTipoTerceraSubasta());
			nmbSubastaInstrucciones.setTotalDeuda(dtoInstrucciones.getTotalDeuda());
			nmbSubastaInstrucciones.setValorSubasta(dtoInstrucciones.getValorSubasta());

			nmbSubastaInstrucciones.setObservacion(dtoInstrucciones.getObservaciones());

			nmbSubastaInstrucciones.setCostasLetrado(dtoInstrucciones.getCostasLetrado());
			nmbSubastaInstrucciones.setCostasProcurador(dtoInstrucciones.getCostasProcurador());
			nmbSubastaInstrucciones.setLimiteConPostores(dtoInstrucciones.getLimiteConPostores());

			if (dtoInstrucciones.getIdPostores() != null) {
				Filter f2 = genericDao.createFilter(FilterType.EQUALS, "id", dtoInstrucciones.getIdPostores());
				DDPostores2 ddPostores = genericDao.get(DDPostores2.class, f2);
				nmbSubastaInstrucciones.setPostores(ddPostores);
			} else {
				nmbSubastaInstrucciones.setPostores(null);
			}

			if (dtoInstrucciones.getNotario() != null) {
				Filter f3 = genericDao.createFilter(FilterType.EQUALS, "id", dtoInstrucciones.getNotario());
				Usuario usuario = genericDao.get(Usuario.class, f3);
				nmbSubastaInstrucciones.setNotario(usuario);
			} else {
				nmbSubastaInstrucciones.setNotario(null);
			}

			genericDao.save(NMBSubastaInstrucciones.class, nmbSubastaInstrucciones);

		}

	}

	@Override
	@BusinessOperation("plugin.clientes.marcarRevisionSolvencia")
	@Transactional(readOnly = false)
	public void marcarRevisioinSolvencia(DtoRevisionSolvencia dto) {

		Long idPersona = dto.getIdPersona();
		String fecha = dto.getFechaRevision();
		System.out.println("marcarRevisioinSolvencia " + idPersona + " " + fecha + " fincabilidad:" + dto.getNoTieneFincabilidad());
		EXTPersona per;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", idPersona);
		per = genericDao.get(EXTPersona.class, f1);

		if (per != null) {
			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
			Date fechaRev;
			try {
				fechaRev = sdf1.parse(fecha);
				per.setFechaRevisionSolvencia(fechaRev);
				per.setObservacionesRevisionSolvencia(dto.getObservacionesRevisionSolvencia());
				if (dto.getNoTieneFincabilidad() == null) {
					per.setNoTieneFincabilidad(false);
				} else {
					per.setNoTieneFincabilidad(true);
				}
				personaDao.saveOrUpdate(per);
			} catch (ParseException e) {
				e.printStackTrace();
			}

		}

		System.out.println("Guardada solvencia");
	}

	@Override
	@BusinessOperation("plugin.clientes.getGestorProveedorSolvencia")
	public String getGestorProveedorSolvencia(Long idPersona) {
		return personaDao.getGestorSolvencias(idPersona);
	}

	@Override
	public NMBBienCargas getCarga(Long idCarga) {
		// TODO Auto-generated method stub

		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", idCarga);
		NMBBienCargas car = genericDao.get(NMBBienCargas.class, f1);

		return car;
	}

	@Override
	@BusinessOperation(BO_GET_BIENES_PERSONAS_CONTRATOS)
	public List<BienProcedimientoDTO> getBienesPersonasContratos(Long idProcedimiento, String accion, String numFinca, String numActivo) {
		List<BienProcedimientoDTO> ret = new ArrayList<BienProcedimientoDTO>();

		List<Bien> bienesPRC = proxyFactory.proxy(ProcedimientoApi.class).getBienesDeUnProcedimiento(idProcedimiento);
		
		if ("AGREGAR".equals(accion)) {
			
			List<Bien> solvencias = proxyFactory.proxy(ProcedimientoApi.class).getSolvenciasDeUnProcedimiento(idProcedimiento);
			
			if(!Checks.estaVacio(solvencias)) {
				DDSolvenciaGarantia solvencia = (DDSolvenciaGarantia) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDSolvenciaGarantia.class,
						DDSolvenciaGarantia.COD_SOLVENCIA);
				for (Bien bien : solvencias) {
					if (!bienesPRC.contains(bien)) {
						ret.add(mapeaBienProcedimientoDTO(bien, solvencia));
					}
				}
			}
			List<Bien> garantias = proxyFactory.proxy(ProcedimientoApi.class).getGarantiasDeUnProcedimiento(idProcedimiento);
			if(!Checks.estaVacio(garantias)) {
				DDSolvenciaGarantia garantia = (DDSolvenciaGarantia) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDSolvenciaGarantia.class,
						DDSolvenciaGarantia.COD_GARANTIA);
				for (Bien bien : garantias) {
					if (!solvencias.contains(bien) && (!bienesPRC.contains(bien))) {
						ret.add(mapeaBienProcedimientoDTO(bien, garantia));
					}
				}
			}
			if (!Checks.esNulo(numFinca) || !Checks.esNulo(numActivo)) {
				List<NMBBien> bienNumFincaActivo = nmbBienDao.getBienesPorNumFincaActivo(numFinca, numActivo);
				if(!Checks.estaVacio(bienNumFincaActivo)) {
					DDSolvenciaGarantia sinRelacion = (DDSolvenciaGarantia) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDSolvenciaGarantia.class,
							DDSolvenciaGarantia.COD_SIN_RELACION);
					for (Bien bien : bienNumFincaActivo) {
						if (!solvencias.contains(bien) && !bienesPRC.contains(bien) && !garantias.contains(bien)) {
							ret.add(mapeaBienProcedimientoDTO(bien, sinRelacion));
						}
					}
				}
			}			
		} else {
			Procedimiento procedimiento = (Procedimiento) proxyFactory.proxy(es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi.class).getProcedimiento(idProcedimiento);
			if (!Checks.esNulo(procedimiento)) {
				List<ProcedimientoBien> prcsBien = procedimiento.getBienes();
				for (ProcedimientoBien procedimientoBien : prcsBien) {
					ret.add(mapeaBienProcedimientoDTO(procedimientoBien.getBien(), procedimientoBien.getSolvenciaGarantia()));
				}
			}
		}

		return ret;
	}

	private BienProcedimientoDTO mapeaBienProcedimientoDTO(Bien bien, DDSolvenciaGarantia solvencia) {
		BienProcedimientoDTO dto = new BienProcedimientoDTO();
		NMBBien nmbBien;
		if (bien instanceof NMBBien) {
			nmbBien = (NMBBien) bien;			
		} else {
			nmbBien = getNMBBien(bien);
		}
		dto.setCodigo(nmbBien.getCodigoInterno());
		dto.setOrigen(nmbBien.getOrigen().getDescripcion());
		dto.setId(bien.getId());
		dto.setDescripcion(bien.getDescripcionBien());
		dto.setTipo(bien.getTipoBien().getDescripcion());
		dto.setReferenciaCatastral(bien.getReferenciaCatastral());
		
		if(!Checks.esNulo(nmbBien.getNumeroActivo())) {
			dto.setNumActivo(Long.valueOf(nmbBien.getNumeroActivo()));
		}
		
		if(!Checks.esNulo(nmbBien.getDatosRegistralesActivo())) {
			dto.setNumFinca(nmbBien.getDatosRegistralesActivo().getNumFinca());
		}
		
		if (!Checks.esNulo(solvencia)) {
			dto.setSolvencia(solvencia.getDescripcion());
			dto.setCodSolvencia(solvencia.getCodigo());
		}
		return dto;
	}

	@Override
	@BusinessOperation(BO_SET_BIENES_PERSONAS_CONTRATOS)
	@Transactional(readOnly = false)
	public void agregarBienes(Long idProcedimiento, String[] arrBien, String[] arrCodSolvencia) {

		Procedimiento procedimiento = (Procedimiento) proxyFactory.proxy(es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi.class).getProcedimiento(idProcedimiento);
		if (!Checks.esNulo(procedimiento)) {
			for (int i = 0; i < arrBien.length; i++) {
				NMBBien bien = nmbBienDao.get(Long.parseLong(arrBien[i]));

				ProcedimientoBien procBien = new ProcedimientoBien();

				procBien.setProcedimiento(procedimiento);
				procBien.setBien(bien);
				if (arrCodSolvencia.length>i) {
					DDSolvenciaGarantia solvenciaGarantia = (DDSolvenciaGarantia) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDSolvenciaGarantia.class, arrCodSolvencia[i]);
					if (!Checks.esNulo(solvenciaGarantia)) {
						procBien.setSolvenciaGarantia(solvenciaGarantia);
					}
				}		
				genericDao.save(ProcedimientoBien.class, procBien);
				
			}

		}
	}

	@Override
	@BusinessOperation(BO_DEL_BIENES_PERSONAS_CONTRATOS)
	@Transactional(readOnly = false)
	public void excluirBienes(Long idProcedimiento, String[] arrBien) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProcedimiento);
		Filter f3 = genericDao.createFilter(FilterType.EQUALS, "borrado", false);

		for (int i = 0; i < arrBien.length; i++) {
			NMBBien bien = nmbBienDao.get(Long.parseLong(arrBien[i]));
			if (!Checks.esNulo(bien)) {
				Filter f2 = genericDao.createFilter(FilterType.EQUALS, "bien.id", bien.getId());
				ProcedimientoBien procBien = genericDao.get(ProcedimientoBien.class, f1, f2, f3);

				genericDao.deleteById(ProcedimientoBien.class, procBien.getId());	
			}
		}

	}
	
	@Override
	@BusinessOperation(BO_BIENES_ASUNTO)
	public List<Bien> getBienesAsunto(Long idAsunto) {
		
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		HashMap<Long, Bien> resultado = new HashMap<Long, Bien>();
		List<Procedimiento> procedimientos = asunto.getProcedimientos();
		for (Procedimiento p : procedimientos){
			List<Bien> bienes = proxyFactory.proxy(ProcedimientoApi.class).getBienesDeUnProcedimiento(p.getId());
			for (Bien b : bienes){
				resultado.put(b.getId(), b);
			}
		}
		
		return  new ArrayList<Bien>(resultado.values());
	}
	
	@Override
	@BusinessOperation(BO_BIENES_ASUNTO_PROCEDIMIENTO)
	public List<DtoNMBBienAdjudicacion> getBienesAsuntoTipoPocedimiento(Long idAsunto,String tipoProcedimiento, Boolean conTareasActivas) {
		
		List<String> tiposProcedimientos = new ArrayList<String>();
		tiposProcedimientos.add(tipoProcedimiento);
		
		List<DtoNMBBienAdjudicacion> bienes = this.getBienesAsuntoTiposPocedimientos(idAsunto, tiposProcedimientos, conTareasActivas);
		List<DtoNMBBienAdjudicacion> bienesResultantes = new ArrayList<DtoNMBBienAdjudicacion>();
		for(DtoNMBBienAdjudicacion dto : bienes){
			if(dto.getTareaActiva()){
				bienesResultantes.add(dto);
			}
		}
		return bienesResultantes;
	}

	@Override
	@BusinessOperation(BO_BIENES_ASUNTO_PROCEDIMIENTOS)
	public List<DtoNMBBienAdjudicacion> getBienesAsuntoTiposPocedimientos(Long idAsunto,List<String> tiposProcedimientos, Boolean soloDeUsuario) {		
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		HashMap<Long, DtoNMBBienAdjudicacion> resultado = new HashMap<Long, DtoNMBBienAdjudicacion>();
		List<Procedimiento> procedimientos = asunto.getProcedimientos();
		List<Long> idProcedimientos = new ArrayList<Long>();
		for (Procedimiento p : procedimientos){
			MEJProcedimiento mejp = proxyFactory.proxy(EXTProcedimientoApi.class).getInstanceOf(p);
			if (!mejp.isEstaParalizado()) {
				for (String tipoProcedimiento : tiposProcedimientos) {
					if(tipoProcedimiento.compareTo(p.getTipoProcedimiento().getCodigo())==0){
						idProcedimientos.add(mejp.getId());
					}
				}
			}
		}
		
		if (!Checks.estaVacio(idProcedimientos)) {
			List<ProcedimientoBien> prcBienes = proxyFactory.proxy(ProcedimientoApi.class).getBienesDeProcedimientos(idProcedimientos);		
			List<? extends TareaExterna> tarea = getTareasProcedimiento(idProcedimientos,soloDeUsuario);
			
			for (ProcedimientoBien procedimientoBien : prcBienes) {
				DtoNMBBienAdjudicacion dto = new DtoNMBBienAdjudicacion();
				dto.setBien(proxyFactory.proxy(BienApi.class).getInstanceOf(procedimientoBien.getBien()));
				dto.setTareaActiva(false);
				dto.setProcedimientoBien(procedimientoBien);
				
				for (TareaExterna tareaExterna : tarea) {
					if (procedimientoBien.getProcedimiento().equals(tareaExterna.getTareaPadre().getProcedimiento())) {
						dto.setTareaNotificacion(tareaExterna.getTareaPadre());
						dto.setDescripcionTarea(tareaExterna.getTareaPadre().getDescripcionTarea());
						dto.setTareaActiva(true);
						
						break;
					}									
				}
				
				resultado.put(procedimientoBien.getProcedimiento().getId(), dto);
			}		
		}
		
		return new ArrayList<DtoNMBBienAdjudicacion>(resultado.values());
	}
	
	
	@Override
	@BusinessOperation(BO_GET_TAREAS_BIEN_ASUNTO)
	public Map<String,TareaNotificacion> getTareasBienAsunto(Long idAsunto, NMBBien bien, Map<String, String> tiposProcedimientos, Boolean soloTareasUsuario) {
		Asunto asunto = extAsuntoDao.get(idAsunto);
		Map<String,TareaNotificacion> valoresTramites = new HashMap<String, TareaNotificacion>();
		Boolean encontrada = false;
		if (!Checks.esNulo(asunto)) {
			/*Obtengo todos los procedimientos del asunto*/
			List<Procedimiento> procedimientos = asunto.getProcedimientos();
			
			for (Procedimiento procedimiento : procedimientos) {				
				MEJProcedimiento mejp = proxyFactory.proxy(EXTProcedimientoApi.class).getInstanceOf(procedimiento);
				encontrada = false;
				/*Solo analizamos los procedimientos del tipo que buscamos*/
				Iterator itTiposPrc = tiposProcedimientos.entrySet().iterator();
				while ((itTiposPrc.hasNext()) && (!encontrada)) {
					Map.Entry e = (Map.Entry)itTiposPrc.next();									
					if( e.getValue().toString().compareTo(mejp.getTipoProcedimiento().getCodigo()) == 0) {
						if (!mejp.isEstaParalizado()){
							/*Obtengo los bienes de ese procedimiento*/
							List<ProcedimientoBien> bienesProcedimiento = mejp.getBienes();							
							for (ProcedimientoBien procedimientoBien : bienesProcedimiento) {
								NMBBien nmbBien = this.getInstanceOf(procedimientoBien.getBien());
								/*Si ese bien está en este procedimiento sacamos sus tareas*/
								if (nmbBien.equals(bien)) {	
									TareaNotificacion tarea = getTareasProcedimiento(mejp, soloTareasUsuario);
									if (!Checks.esNulo(tarea)) {
										valoresTramites.put(e.getKey().toString(), tarea);
									}
									//Aunque no se haya encontrado ninguna tarea se pone el semáforo=true porque este bien ya se ha encontrado
									encontrada = true;
								}
								if (encontrada) {
									break;
								}
							}
						} else {
							//Si el proc. esta paralizado pasamos al siguiente procedimiento
							encontrada = true;
						}
					}
				}
			}
		}		
		return valoresTramites;
	}
	

	private TareaNotificacion getTareasProcedimiento(MEJProcedimiento mejp, Boolean soloDeUsuario) {
		/*Buscamos las tareas del usuario*/	
		List<? extends TareaExterna> tareasExternas = proxyFactory.proxy(TareaExternaApi.class).obtenerTareasDeUsuarioPorProcedimiento(mejp.getId());
		for (TareaExterna tareaExterna : tareasExternas) {
			return tareaExterna.getTareaPadre();
		}
		if (!soloDeUsuario) {
			//Si no hay tareas para ese usuario se obtienen todas
			Set<TareaNotificacion> tareas = mejp.getTareas();
			Iterator<TareaNotificacion> it = tareas.iterator();
			while (it.hasNext()){
				TareaNotificacion tarea = it.next();
				if(tarea.getTareaFinalizada() == null || !tarea.getTareaFinalizada()){
					return tarea;
				}
			}
		}
		return null;
	}

	private List<? extends TareaExterna> getTareasProcedimiento(List<Long> idProcedimientos, Boolean soloDeUsuario) {
		/*Buscamos las tareas del usuario*/	
		if (soloDeUsuario) {
			return proxyFactory.proxy(TareaExternaApi.class).obtenerTareasDeUsuarioPorProcedimientos(idProcedimientos);
		} else {
			return proxyFactory.proxy(TareaExternaApi.class).obtenerTareasPorProcedimientos(idProcedimientos);
		}
//		for (TareaExterna tareaExterna : tareasExternas) {
//			return tareaExterna.getTareaPadre();
//		}
		//TODO - Se comenta por optimización, revisar otra forma de hacerlo
//		if (!soloDeUsuario) {		
//			//Si no hay tareas para ese usuario se obtienen todas
//			Set<TareaNotificacion> tareas = mejp.getTareas();
//			Iterator<TareaNotificacion> it = tareas.iterator();
//			while (it.hasNext()){
//				TareaNotificacion tarea = it.next();
//				if(tarea.getTareaFinalizada() == null || !tarea.getTareaFinalizada()){
//					return tarea;
//				}
//			}
//		}
//		return null;
	}

	@Override
	@BusinessOperation(BO_BIEN_GET_INSTANCE_OF)
	public NMBBien getInstanceOf(Bien bien) {
		if (bien instanceof NMBBien) {
			return (NMBBien) bien;
		}
		if (Hibernate.getClass(bien).equals(NMBBien.class)) {
			HibernateProxy proxy = (HibernateProxy) bien;				
			return((NMBBien) proxy.writeReplace());
		}
		return null;
	}
	
	@Override
	@BusinessOperation(BO_GET_TAREA_BIEN)
	public TareaNotificacion getTareaNotificacionBien(Long idAsunto, Long idBien, String tipoProcedimiento, Boolean soloTareasUsuario) {
		/*Obtenemos el bien*/
		NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(idBien);
		if (Checks.esNulo(bien)) {
			return null;
		}
		
		/*Como el método necesita un map, añadimos el tipo de Procedimiento al map*/
		Map<String, String> tiposProcedimientos = new HashMap<String, String>();
		tiposProcedimientos.put(tipoProcedimiento, tipoProcedimiento);
		
		/*Obtenemos la tarea de ese bien, en ese asunto y tipo de procedimiento*/
		Map<String,TareaNotificacion> mapTareas = this.getTareasBienAsunto(idAsunto, bien, tiposProcedimientos, soloTareasUsuario);
		
		/*Recuperamos del map por la Key que le hemos añadido antes, en este caso el tipoProcedimiento*/
		TareaNotificacion tarea = mapTareas.get(tipoProcedimiento);
		
		return tarea;
	}
	
	@Override
	@BusinessOperation(BO_COMPROBAR_HITO_BIEN)
	public Boolean comprobarHitoBien(Long idAsunto, String[] arrBien, String tipoProcedimiento, Boolean soloTareasUsuario) {
		String codigoTarea = null;
		for (String idBien : arrBien) {			
			
			/*Obtenemos la tarea del bien del asunto*/
			TareaNotificacion tarea = getTareaNotificacionBien(idAsunto, Long.parseLong(idBien), tipoProcedimiento, soloTareasUsuario);			
			
			if (!Checks.esNulo(tarea)) {
				if (Checks.esNulo(codigoTarea)) {
					/*Utilizamos la variable "codigoTarea" para comparar el resto de bienes, solo la inicializamos la primera vez*/
					codigoTarea = tarea.getTareaExterna().getTareaProcedimiento().getCodigo();
				}
				if (codigoTarea.compareTo(tarea.getTareaExterna().getTareaProcedimiento().getCodigo())!=0) {
					/*Si algún bien no coincide su tarea ya no seguimos mirando y devolvemos false*/
					return false;
				}
			} else {
				/*Si no tiene tareas devolvemos false*/
				return false;
			}
		}
		/*Si ha llegado hasta aquí es que todas las tareas son iguales*/
		return true;
	}
	
	@Override
	@BusinessOperation(GET_LIST_LOCALIDADES)
	public List<Localidad> getListLocalidades(String codProvincia) {

		if (codProvincia != null) {
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "provincia.codigo", codProvincia);
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "provincia.auditoria.borrado", false);
			
			List<Localidad> list = (ArrayList<Localidad>) genericDao.getList(Localidad.class, f1, f2);

			return list;
		}
		return null;
	}
	
	@Override
	@BusinessOperation(GET_LIST_UNIDADES_POBLACIONALES)
	public List<DDUnidadPoblacional> getListUnidadesPoblacionales(String codLocalidad) {

		if (codLocalidad != null) {
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "localidad.codigo", codLocalidad);
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			List<DDUnidadPoblacional> list = (ArrayList<DDUnidadPoblacional>) genericDao.getList(DDUnidadPoblacional.class, f1, f2);

			return list;
		}
		return null;
	}
	
	@Override
	@BusinessOperation(GET_LIST_PAISES)
	public List<DDCicCodigoIsoCirbeBKP> getListPaises() {

		Filter f = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<DDCicCodigoIsoCirbeBKP> list = (ArrayList<DDCicCodigoIsoCirbeBKP>) genericDao.getList(DDCicCodigoIsoCirbeBKP.class, f);
		return list;
	}
	
	@Override
	@BusinessOperation(GET_LIST_TIPOS_VIA)
	public List<DDTipoVia> getListTiposVia() {

		Filter f = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<DDTipoVia> list = (ArrayList<DDTipoVia>) genericDao.getList(DDTipoVia.class, f);
		return list;
	}
	
	@Override
	@BusinessOperation(GET_NUMEROS_ACTIVOS_BIENES)
	public Map<String, String> getNumerosActivosBienes(final String[] arrBienes) {
		if (arrBienes == null) {
			return new HashMap<String, String>();
		}

		final String errValidacion = "ERROR_VALIDACION";
		final String errSolicitud = "ERROR_SOLICITUD";

		final Map<String, String> mapResults = new HashMap<String, String>();
		for (int i = 0; i < arrBienes.length; i++) {
			final String idBienStr = arrBienes[i];
			final Long idBien = Long.parseLong(idBienStr);
			NMBBien bien = nmbBienDao.get(idBien);
			if (bien.getNumeroActivo() == null || bien.getNumeroActivo().equals("0")) {
				if (validarProvLocFinBien(bien)) {
					final String respuesta = proxyFactory.proxy(SubastasServicioTasacionDelegateApi.class).solicitarNumeroActivoConRespuesta(idBien);
					if (!respuesta.equals("1")) {
						//La respuesta del servicio no es correcta.
						mapResults.put(idBienStr, errSolicitud);
					}
				} else {
					//Faltan datos para solicitar el n�mero de activo.
					mapResults.put(idBienStr, errValidacion);
				}
			}
		}
		return mapResults;
	}
	
	private boolean validarProvLocFinBien(final NMBBien bien) {
		if (Checks.esNulo(bien.getAdicional()) || Checks.esNulo(bien.getAdicional().getTipoInmueble()) || Checks.esNulo(bien.getAdicional().getTipoInmueble().getCodigo())) {
			return false;
		}
		if (Checks.esNulo(bien.getDatosRegistralesActivo()) || Checks.esNulo(bien.getDatosRegistralesActivo().getNumFinca())) {
			return false;
		}
		if (Checks.esNulo(bien.getLocalizacionActual())) {
			return false;
		}
		if (Checks.esNulo(bien.getLocalizacionActual().getLocalidad()) || Checks.esNulo(bien.getLocalizacionActual().getLocalidad().getDescripcion())) {
			return false;
		}
		if (Checks.esNulo(bien.getLocalizacionActual().getProvincia()) || Checks.esNulo(bien.getLocalizacionActual().getProvincia().getDescripcion())) {
			return false;
		}
		if (Checks.esNulo(bien.getDatosRegistralesActivo()) || Checks.esNulo(bien.getDatosRegistralesActivo().getNumRegistro())) {
			return false;
		}
		return true;
	}
	
}
