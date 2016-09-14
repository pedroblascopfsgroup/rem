package es.pfsgroup.plugin.rem.expedienteComercial;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.ComparecienteVendedor;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.DtoActivosExpediente;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoExpediente;
import es.pfsgroup.plugin.rem.model.DtoComparecienteVendedor;
import es.pfsgroup.plugin.rem.model.DtoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoDatosBasicosOferta;
import es.pfsgroup.plugin.rem.model.DtoEntregaReserva;
import es.pfsgroup.plugin.rem.model.DtoFichaExpediente;
import es.pfsgroup.plugin.rem.model.DtoFormalizacionResolucion;
import es.pfsgroup.plugin.rem.model.DtoGastoExpediente;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoPosicionamiento;
import es.pfsgroup.plugin.rem.model.DtoReserva;
import es.pfsgroup.plugin.rem.model.DtoSubsanacion;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Formalizacion;
import es.pfsgroup.plugin.rem.model.ObservacionesExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Posicionamiento;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.Subsanaciones;
import es.pfsgroup.plugin.rem.model.TextosOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoFinanciacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.model.dd.DDTiposTextoOferta;
import es.pfsgroup.plugin.rem.observacionesExpediente.dao.ObservacionExpedienteDao;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.reserva.dao.ReservaDao;


@Service("expedienteComercialManager")
public class ExpedienteComercialManager implements ExpedienteComercialApi {
	
	protected static final Log logger = LogFactory.getLog(ExpedienteComercialManager.class);
	
	public final String PESTANA_FICHA = "ficha";
	public final String PESTANA_DATOSBASICOS_OFERTA = "datosbasicosoferta";
	public final String PESTANA_RESERVA = "reserva";
	public final String PESTANA_CONDICIONES = "condiciones";
	public final String PESTANA_FORMALIZACION= "formalizacion";

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private OfertaDao ofertaDao;
	
	@Autowired
	private ReservaDao reservaDao;
	
	
	@Autowired
	private ObservacionExpedienteDao observacionComercialDao;
	
	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	

	@Override
	public ExpedienteComercial findOne(Long id) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);

		return expediente;
	}

	@Override
	public Object getTabExpediente(Long id, String tab) {
		
		ExpedienteComercial expediente = findOne(id);
		
		WebDto dto = null;

		try {
			
			if(PESTANA_FICHA.equals(tab)){
				dto = expedienteToDtoFichaExpediente(expediente);
			} else if (PESTANA_DATOSBASICOS_OFERTA.equals(tab)) {
				dto = expedienteToDtoDatosBasicosOferta(expediente);
			} else if (PESTANA_RESERVA.equals(tab)) {
				dto = expedienteToDtoReserva(expediente);
			} else if (PESTANA_CONDICIONES.equals(tab)) {
				dto = expedienteToDtoCondiciones(expediente);
			}
			else if(PESTANA_FORMALIZACION.equals(tab)) {
				dto= expedienteToDtoFormalizacion(expediente);
			}
			

		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		return dto;

	}

	@Override
	public List<DtoTextosOferta> getListTextosOfertaById (Long idExpediente) {
		
		ExpedienteComercial expediente = findOne(idExpediente);
		Oferta oferta = expediente.getOferta();		
		List<Dictionary> tiposTexto = genericAdapter.getDiccionario("tiposTextoOferta");		
		Long idOferta = null;
		
		if(!Checks.esNulo(oferta)) {
			idOferta = oferta.getId();
		}		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", idOferta);	
		List<TextosOferta> lista = (List<TextosOferta>) genericDao.getList(TextosOferta.class, filtro);
		List<DtoTextosOferta> textos = new ArrayList<DtoTextosOferta>();
		
		for (TextosOferta textoOferta: lista) {
			
			DtoTextosOferta texto = new DtoTextosOferta();
			texto.setId(textoOferta.getId());
			texto.setCampoDescripcion(textoOferta.getTipoTexto().getDescripcion());
			texto.setCampoCodigo(textoOferta.getTipoTexto().getCodigo());
			texto.setTexto(textoOferta.getTexto());
			textos.add(texto);
			// Sólamente habrá un tipo de texto por oferta, de esta manera conseguimos tener en la lista todos los tipos,
			// tengan valor o no
			tiposTexto.remove(textoOferta.getTipoTexto());
		}
		
		// Añadimos los tipos que no han sido nunca creados para esta oferta
		Long contador = new Long(-1);
		for (Dictionary tipoTextoOferta: tiposTexto) {
			DtoTextosOferta texto = new DtoTextosOferta();
			texto.setId(contador--);
			texto.setCampoDescripcion(tipoTextoOferta.getDescripcion());
			texto.setCampoCodigo(tipoTextoOferta.getCodigo());
			textos.add(texto);			
		}	
		
		return textos;
		
	}
	
	@Override
	public List<DtoEntregaReserva> getListEntregasReserva(Long id) {
		
		ExpedienteComercial expediente = findOne(id);
		List<DtoEntregaReserva> lista = new ArrayList<DtoEntregaReserva>();
		
		if(!Checks.esNulo(expediente.getReserva())) {
			
			for(EntregaReserva entrega: expediente.getReserva().getEntregas()) {
				DtoEntregaReserva entregaReserva = new DtoEntregaReserva();
				
				entregaReserva.setIdEntrega(entrega.getId());
				entregaReserva.setFechaCobro(entrega.getFechaEntrega());
				entregaReserva.setImporte(entrega.getImporte());
				entregaReserva.setObservaciones(entrega.getObservaciones());
				entregaReserva.setTitular(entrega.getTitular());	
				
				lista.add(entregaReserva);

			}
		}
		return lista;
	}
	

	@Override
	@Transactional(readOnly = false)
	public boolean saveTextoOferta(DtoTextosOferta dto, Long idEntidad) {
		
		TextosOferta textoOferta = null;
		
		ExpedienteComercial expedienteComercial = findOne(idEntidad);
		Oferta oferta = expedienteComercial.getOferta();
		
		// Estamos creando un texto que no existia
		if(dto.getId()<0) {
			textoOferta = new TextosOferta();
			textoOferta.setOferta(oferta);
			textoOferta.setTexto(dto.getTexto());
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCampoCodigo());
			DDTiposTextoOferta tipoTexto = genericDao.get(DDTiposTextoOferta.class, filtro);			
			textoOferta.setTipoTexto(tipoTexto);
		// Modificamos un texto existente	
		} else {			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getId());
			textoOferta = genericDao.get(TextosOferta.class, filtro);
			textoOferta.setTexto(dto.getTexto());			
		}
		
		genericDao.save(TextosOferta.class, textoOferta);
		
		return true;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveDatosBasicosOferta(DtoDatosBasicosOferta dto, Long idExpediente) {
		
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		Oferta oferta = expedienteComercial.getOferta();
		
		if(!Checks.esNulo(dto.getEstadoVisitaOfertaCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoVisitaOfertaCodigo());
			DDEstadosVisitaOferta estado = genericDao.get(DDEstadosVisitaOferta.class, filtro);	
			oferta.setEstadoVisitaOferta(estado);	
		}
		
		expedienteComercial.setOferta(oferta);
		
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		
		return true;
	}


	private DtoFichaExpediente expedienteToDtoFichaExpediente(ExpedienteComercial expediente) {

		DtoFichaExpediente dto = new DtoFichaExpediente();
		Oferta oferta = null;
		Activo activo = null;
		
		if(!Checks.esNulo(expediente)) {
			
			oferta = expediente.getOferta();
			if(!Checks.esNulo(oferta)) {
				activo = oferta.getActivoPrincipal();
			}
			
			dto.setId(expediente.getId());
		
			if(!Checks.esNulo(oferta) && !Checks.esNulo(activo)) {		
			
				dto.setNumExpediente(expediente.getNumExpediente());	
				if(!Checks.esNulo(activo.getCartera())) {
					dto.setEntidadPropietariaDescripcion(activo.getCartera().getDescripcion());
				}	
				
				if(!Checks.esNulo(oferta.getTipoOferta())) {
					dto.setTipoExpedienteDescripcion(oferta.getTipoOferta().getDescripcion());
					dto.setTipoExpedienteCodigo(oferta.getTipoOferta().getCodigo());
				}
				
				dto.setPropietario(activo.getFullNamePropietario());		
				if(!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
					dto.setMediador(activo.getInfoComercial().getMediadorInforme().getNombre());
				}
				
				dto.setImporte(oferta.getImporteOferta());
				if(!Checks.esNulo(expediente.getCompradorPrincipal())) {
					dto.setComprador(expediente.getCompradorPrincipal().getFullName());
				}
				
				if(!Checks.esNulo(expediente.getEstado())) {
					dto.setEstado(expediente.getEstado().getDescripcion());
				}		
				dto.setFechaAlta(expediente.getFechaAlta());
				dto.setFechaAltaOferta(oferta.getFechaAlta());
				dto.setFechaSancion(expediente.getFechaSancion());
				
				if(!Checks.esNulo(expediente.getReserva())) {
					dto.setFechaReserva(expediente.getReserva().getFechaEnvio());
				}
				
				if(!Checks.esNulo(oferta.getAgrupacion())) {
					dto.setIdAgrupacion(oferta.getAgrupacion().getId());
					dto.setNumEntidad(oferta.getAgrupacion().getNumAgrupRem());
				} else {
					dto.setIdActivo(activo.getId());
					dto.setNumEntidad(activo.getNumActivo());
				}
				
				if(!Checks.esNulo(expediente.getUltimoPosicionamiento())) {
					dto.setFechaPosicionamiento(expediente.getUltimoPosicionamiento().getFechaPosicionamiento());					
				}
				
				dto.setMotivoAnulacion(expediente.getMotivoAnulacion());
				dto.setFechaAnulacion(expediente.getFechaAnulacion());
				dto.setPeticionarioAnulacion(expediente.getPeticionarioAnulacion());
				dto.setFechaContabilizacionPropietario(expediente.getFechaContabilizacionPropietario());
				dto.setFechaDevolucionEntregas(expediente.getFechaDevolucionEntregas());
				dto.setImporteDevolucionEntregas(expediente.getImporteDevolucionEntregas());
				
				if(!Checks.esNulo(expediente.getCondicionante())) {
					dto.setTieneReserva(expediente.getCondicionante().getTipoCalculoReserva() != null);
				}
				

			}
		}
		
		return dto;
	}
	
	private DtoDatosBasicosOferta expedienteToDtoDatosBasicosOferta(ExpedienteComercial expediente) {
		
		DtoDatosBasicosOferta dto = new DtoDatosBasicosOferta();
		Oferta oferta = expediente.getOferta();
		
		dto.setIdOferta(oferta.getId());
		dto.setNumOferta(oferta.getNumOferta());
		if(!Checks.esNulo(oferta.getTipoOferta())) {
			dto.setTipoOfertaDescripcion(oferta.getTipoOferta().getDescripcion());
		}
		dto.setFechaNotificacion(oferta.getFechaNotificacion());
		dto.setFechaAlta(oferta.getFechaAlta());
		if(!Checks.esNulo(oferta.getEstadoOferta())) {
			dto.setEstadoDescripcion(oferta.getEstadoOferta().getDescripcion());
		}
		if(!Checks.esNulo(oferta.getPrescriptor()) && !Checks.esNulo(oferta.getPrescriptor().getTipoColaborador())) {
			dto.setPrescriptorDescripcion(oferta.getPrescriptor().getTipoColaborador().getDescripcion());
		}
		dto.setImporteOferta(oferta.getImporteOferta());
		dto.setImporteContraoferta(oferta.getImporteContraOferta());
		
		// TODO Comités sin definir
		//dto.setComite();
		
		if(!Checks.esNulo(oferta.getVisita())) {
			dto.setNumVisita(oferta.getVisita().getNumVisitaRem());
		}
		
		if(!Checks.esNulo(oferta.getEstadoVisitaOferta())) {
			dto.setEstadoVisitaOfertaCodigo(oferta.getEstadoVisitaOferta().getCodigo());
			dto.setEstadoVisitaOfertaDescripcion(oferta.getEstadoVisitaOferta().getDescripcion());
		}
		
				
		return dto;
	}
	
	private DtoReserva expedienteToDtoReserva(ExpedienteComercial expediente) {
		DtoReserva dto = new DtoReserva();
		
		Reserva reserva = expediente.getReserva();
		
		if(!Checks.esNulo(reserva)) {
			
			dto.setIdReserva(reserva.getId());
			dto.setNumReserva(reserva.getNumReserva());			
			dto.setFechaEnvio(reserva.getFechaEnvio());
			dto.setFechaFirma(reserva.getFechaFirma());
			dto.setFechaVencimiento(reserva.getFechaVencimiento());
			if(!Checks.esNulo(reserva.getEstadoReserva())) {
				dto.setEstadoReservaDescripcion(reserva.getEstadoReserva().getDescripcion());
			}
			
			if(!Checks.esNulo(reserva.getTipoArras())) {
				dto.setTipoArrasCodigo(reserva.getTipoArras().getCodigo());
			}	
			if(!Checks.esNulo(expediente.getCondicionante())) {
				dto.setConImpuesto(expediente.getCondicionante().getReservaConImpuesto());
				dto.setImporte(expediente.getCondicionante().getImporteReserva());
			}
		}
		
		
		return dto;
	}
	
	@Override
	public DtoPage getListObservaciones(Long idExpediente) {
		
		List<ObservacionesExpedienteComercial> lista = observacionComercialDao.getList();
		List<DtoObservacion> observaciones = new ArrayList<DtoObservacion>();
		
		for (ObservacionesExpedienteComercial observacion: lista) {
			
			DtoObservacion dtoObservacion = observacionToDto(observacion);
			observaciones.add(dtoObservacion);
		}
		
		return new DtoPage(observaciones, observaciones.size());
	}
	
	@Transactional(readOnly = false)
	public boolean saveObservacion(DtoObservacion dtoObservacion) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoObservacion.getId()));
		ObservacionesExpedienteComercial observacion = genericDao.get(ObservacionesExpedienteComercial.class, filtro);
		
		try {
			
			beanUtilNotNull.copyProperties(observacion, dtoObservacion);			
			genericDao.save(ObservacionesExpedienteComercial.class, observacion);
			
			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return true;
		
	}
	
	@Transactional(readOnly = false)
	public boolean createObservacion(DtoObservacion dtoObservacion, Long idExpediente) {
		
		ObservacionesExpedienteComercial observacion = new ObservacionesExpedienteComercial();
		ExpedienteComercial expediente = findOne(idExpediente);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		try {
			
			observacion.setObservacion(dtoObservacion.getObservacion());
			observacion.setFecha(new Date());
			observacion.setUsuario(usuarioLogado);
			observacion.setExpediente(expediente);
			
			genericDao.save(ObservacionesExpedienteComercial.class, observacion);

			
		} catch (Exception e) {
			e.printStackTrace();
		} 

		return true;
		
	}
	
	@Transactional(readOnly = false)
	public boolean deleteObservacion(Long idObservacion) {
		
		try {
			
			genericDao.deleteById(ObservacionesExpedienteComercial.class, idObservacion);
			
		} catch (Exception e) {
			e.printStackTrace();
		} 

		return true;
		
	}
	
	/**
	 * Parsea una observacion a objeto Dto.
	 * @param observacion
	 * @return
	 */
	private DtoObservacion observacionToDto(ObservacionesExpedienteComercial observacion) {
		
		DtoObservacion observacionDto = new DtoObservacion();
		
		try {
			
			String nombreCompleto = observacion.getUsuario().getNombre();
			Long idUsuario = observacion.getUsuario().getId();
			
			if (observacion.getUsuario().getApellido1() != null) {
				
				nombreCompleto += observacion.getUsuario().getApellido1();
				
				if (observacion.getUsuario().getApellido2() != null) {
					nombreCompleto += observacion.getUsuario().getApellido2();
				}
				
			}
			
			if(!Checks.esNulo(observacion.getAuditoria().getFechaModificar())){
				observacionDto.setFechaModificacion(observacion.getAuditoria().getFechaModificar());				
			}

			BeanUtils.copyProperties(observacionDto, observacion);
			observacionDto.setNombreCompleto(nombreCompleto);
			observacionDto.setIdUsuario(idUsuario);
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return observacionDto;
	}
	
	@Override
	public DtoPage getActivosExpediente(Long idExpediente) {
		
		ExpedienteComercial expediente= findOne(idExpediente);
		List<DtoActivosExpediente> activos= new ArrayList<DtoActivosExpediente>();
		List<ActivoOferta> activosExpediente= expediente.getOferta().getActivosOferta();
		List<Activo> listaActivosExpediente= new ArrayList<Activo>();
		
		//Se crea un mapa para cada dato que se quiere obtener
		Map<Activo,Float> activoPorcentajeParti= new HashMap<Activo, Float>();	
		Map<Activo,Double> activoPrecioAprobado= new HashMap<Activo, Double>();
		Map<Activo,Double> activoPrecioMinimo= new HashMap<Activo, Double>();
		Map<Activo,Double> activoImporteParticipacion= new HashMap<Activo, Double>();
		
		//Recorre los activos de la oferta y los añade a la lista de activos a mostrar
		for(ActivoOferta activoOferta: activosExpediente){
			listaActivosExpediente.add(activoOferta.getPrimaryKey().getActivo());
		}
		
		//Recorre la relacion activo-trabajo del expediente, por cada una guarda en un mapa el porcentaje de participacion del activo y el importe calculado a partir de dicho porcentaje
		if(!Checks.esNulo(expediente.getTrabajo())){
			for(ActivoTrabajo activoTrabajo: expediente.getTrabajo().getActivosTrabajo()){
				activoPorcentajeParti.put(activoTrabajo.getPrimaryKey().getActivo(), activoTrabajo.getParticipacion());
				activoImporteParticipacion.put(activoTrabajo.getPrimaryKey().getActivo(), 
												(expediente.getOferta().getImporteOferta()*activoTrabajo.getParticipacion())/100);
			}
		}

		//Por cada activo recorre todas sus valoraciones para adquirir el precio aprobado de venta y el precio minimo autorizado
		for(Activo activo: listaActivosExpediente){
			for(ActivoValoraciones valoracion: activo.getValoracion()){
				if(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(valoracion.getTipoPrecio().getCodigo())){
					activoPrecioAprobado.put(activo, valoracion.getImporte());
				}
				if(DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO.equals(valoracion.getTipoPrecio().getCodigo())){
					activoPrecioMinimo.put(activo, valoracion.getImporte());
				}
				
			}
			
			//Convierte todos los datos obtenidos en un dto
			DtoActivosExpediente dtoActivo= activosToDto(activo, activoPorcentajeParti, activoPrecioAprobado,activoPrecioMinimo, activoImporteParticipacion);
			activos.add(dtoActivo);
		}
		
		return new DtoPage(activos, activos.size());
	}
	
	/**
	 * Parsea un activo a objeto Dto.
	 * @param activo
	 * @return
	 */
	private DtoActivosExpediente activosToDto(Activo activo, Map<Activo,Float> activoPorcentajeParti, Map<Activo,Double> activoPrecioAprobado, 
												Map<Activo,Double> activoPrecioMinimo, Map<Activo,Double> activoImporteParticipacion) {
		
		DtoActivosExpediente dtoActivo= new DtoActivosExpediente();
		
		try{
			dtoActivo.setIdActivo(activo.getId());
			dtoActivo.setNumActivo(activo.getNumActivo());
			dtoActivo.setSubtipoActivo(activo.getSubtipoActivo().getDescripcion());
			//Falta precio minimo y precio aprobado venta
			
			if(!Checks.estaVacio(activoPorcentajeParti)){
				dtoActivo.setPorcentajeParticipacion(activoPorcentajeParti.get(activo));
			}
			if(!Checks.estaVacio(activoPrecioAprobado)){
				dtoActivo.setPrecioAprobadoVenta(activoPrecioAprobado.get(activo));
			}
			if(!Checks.estaVacio(activoPrecioMinimo)){
				dtoActivo.setPrecioMinimo(activoPrecioMinimo.get(activo));
			}
			if(!Checks.estaVacio(activoImporteParticipacion)){
				dtoActivo.setImporteParticipacion((activoImporteParticipacion.get(activo)));
			}
			
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return dtoActivo;
	}
	
	public FileItem getFileItemAdjunto(DtoAdjuntoExpediente dtoAdjunto) {
		
		ExpedienteComercial expediente = findOne(dtoAdjunto.getIdExpediente());
		AdjuntoExpedienteComercial adjuntoExpediente = expediente.getAdjunto(dtoAdjunto.getId());
		
		FileItem fileItem = adjuntoExpediente.getAdjunto().getFileItem();
		fileItem.setContentType(adjuntoExpediente.getContentType());
		fileItem.setFileName(adjuntoExpediente.getNombre());
		
		return adjuntoExpediente.getAdjunto().getFileItem();
	}
	
	@Override
	public List<DtoAdjuntoExpediente> getAdjuntos(Long idExpediente) {
		
		List<DtoAdjuntoExpediente> listaAdjuntos = new ArrayList<DtoAdjuntoExpediente>();
		
		try{
			ExpedienteComercial expediente = findOne(idExpediente);

			for (AdjuntoExpedienteComercial adjunto : expediente.getAdjuntos()) {
				DtoAdjuntoExpediente dto = new DtoAdjuntoExpediente();
				
				BeanUtils.copyProperties(dto, adjunto);
				dto.setIdExpediente(expediente.getId());
				dto.setDescripcionTipo(adjunto.getTipoDocumentoExpediente().getDescripcion());
				dto.setDescripcionSubtipo(adjunto.getSubtipoDocumentoExpediente().getDescripcion());
				dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());				
				
				listaAdjuntos.add(dto);
			}
		
		}catch(Exception ex){
			ex.printStackTrace();
		}

		return listaAdjuntos;
	}
	
	@Override
	@Transactional(readOnly = false)
	public String upload(WebFileItem fileItem) throws Exception {

		//Subida de adjunto al Expediente Comercial
		ExpedienteComercial expediente = findOne(Long.parseLong(fileItem.getParameter("idEntidad")));
		
		Adjunto adj = uploadAdapter.saveBLOB(fileItem.getFileItem());
		
		AdjuntoExpedienteComercial adjuntoExpediente = new AdjuntoExpedienteComercial();
		adjuntoExpediente.setAdjunto(adj);
		
		adjuntoExpediente.setExpediente(expediente);

		//Setear tipo y subtipo del adjunto a subir
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
		adjuntoExpediente.setTipoDocumentoExpediente((DDTipoDocumentoExpediente) genericDao.get(DDTipoDocumentoExpediente.class, filtro));
		
		filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("subtipo"));
		adjuntoExpediente.setSubtipoDocumentoExpediente((DDSubtipoDocumentoExpediente) genericDao.get(DDSubtipoDocumentoExpediente.class, filtro));
		
		
		adjuntoExpediente.setContentType(fileItem.getFileItem().getContentType());
		adjuntoExpediente.setTamanyo(fileItem.getFileItem().getLength());
		adjuntoExpediente.setNombre(fileItem.getFileItem().getFileName());
		adjuntoExpediente.setDescripcion(fileItem.getParameter("descripcion"));
		adjuntoExpediente.setFechaDocumento(new Date());
		Auditoria.save(adjuntoExpediente);
        
		expediente.getAdjuntos().add(adjuntoExpediente);		
		
		genericDao.save(ExpedienteComercial.class, expediente);
	        
		return null;

	}
	@Override
	@Transactional(readOnly = false)
	public boolean deleteAdjunto(DtoAdjuntoExpediente dtoAdjunto) {
		ExpedienteComercial expediente = findOne(dtoAdjunto.getIdExpediente());
		AdjuntoExpedienteComercial adjunto = expediente.getAdjunto(dtoAdjunto.getId());
		
	    if (adjunto == null) { return false; }
	    expediente.getAdjuntos().remove(adjunto);
	    genericDao.save(ExpedienteComercial.class, expediente);
	    
	    return true;
	}

	private DtoCondiciones expedienteToDtoCondiciones(ExpedienteComercial expediente) {
		
		DtoCondiciones dto = new DtoCondiciones(); 
		CondicionanteExpediente condiciones = expediente.getCondicionante();
		
		//Si el expediente pertenece a una agrupacion miramos el activo principal
		if(!Checks.esNulo(expediente.getOferta().getAgrupacion())){
			
			Activo activoPrincipal= expediente.getOferta().getActivoPrincipal();
			
			if(!Checks.esNulo(activoPrincipal)){
				dto.setFechaUltimaActualizacion(activoPrincipal.getFechaRevisionCarga());
				dto.setVpo(activoPrincipal.getVpo());
				
				if(!Checks.esNulo(activoPrincipal.getSituacionPosesoria())){
				
					dto.setFechaTomaPosesion(activoPrincipal.getSituacionPosesoria().getFechaTomaPosesion());
					dto.setOcupado(activoPrincipal.getSituacionPosesoria().getOcupado());
					dto.setConTitulo(activoPrincipal.getSituacionPosesoria().getConTitulo());
					if(!Checks.esNulo(activoPrincipal.getSituacionPosesoria().getTipoTituloPosesorio())){
						dto.setTipoTitulo(activoPrincipal.getSituacionPosesoria().getTipoTituloPosesorio().getDescripcion());
					}
				}	
			}
			
			
		}
		else{
			
			Activo activo= expediente.getOferta().getActivosOferta().get(0).getPrimaryKey().getActivo();
			
			if(!Checks.esNulo(activo)){
				dto.setFechaUltimaActualizacion(activo.getFechaRevisionCarga());
				dto.setVpo(activo.getVpo());
				
				if(!Checks.esNulo(activo.getSituacionPosesoria())){
					dto.setFechaTomaPosesion(activo.getSituacionPosesoria().getFechaTomaPosesion());
					dto.setOcupado(activo.getSituacionPosesoria().getOcupado());
					dto.setConTitulo(activo.getSituacionPosesoria().getConTitulo());
					if(!Checks.esNulo(activo.getSituacionPosesoria().getTipoTituloPosesorio())){
						dto.setTipoTitulo(activo.getSituacionPosesoria().getTipoTituloPosesorio().getDescripcion());
					}
				}
				
			}
			
		}
		
		if(!Checks.esNulo(condiciones)){
			//Economicas-Financiación
			dto.setSolicitaFinanciacion(condiciones.getSolicitaFinanciacion());
			if(!Checks.esNulo(condiciones.getEstadoFinanciacion())){
				dto.setEstadosFinanciacion(condiciones.getEstadoFinanciacion().getCodigo());
			}
			dto.setEntidadFinanciacion(condiciones.getEntidadFinanciacion());			
			dto.setEstadoTramite(condiciones.getEstadoTramite());
			dto.setFechaInicioExpediente(condiciones.getFechaInicioExpediente());
			dto.setFechaInicioFinanciacion(condiciones.getFechaInicioFinanciacion());
			dto.setFechaFinFinanciacion(condiciones.getFechaFinFinanciacion());
			
			//Economicas-Reserva
			if(!Checks.esNulo(condiciones.getTipoCalculoReserva())){
				dto.setTipoCalculo(condiciones.getTipoCalculoReserva().getCodigo());
			}
			dto.setPorcentajeReserva(condiciones.getPorcentajeReserva());
			dto.setPlazoFirmaReserva(condiciones.getPlazoFirmaReserva());
			dto.setImporteReserva(condiciones.getImporteReserva());
			
			//Economicas-Fiscales
			if(!Checks.esNulo(condiciones.getTipoImpuesto())){
				dto.setTipoImpuestoCodigo(condiciones.getTipoImpuesto().getCodigo());
			}
			dto.setTipoAplicable(condiciones.getTipoAplicable());
			dto.setRenunciaExencion(condiciones.getRenunciaExencion());
			dto.setReservaConImpuesto(condiciones.getReservaConImpuesto());
						
			//Economicas-Gastos Compraventa
			dto.setGastosPlusvalia(condiciones.getGastosPlusvalia());
			if(!Checks.esNulo(condiciones.getTipoPorCuentaPlusvalia())){
				dto.setPlusvaliaPorCuentaDe(condiciones.getTipoPorCuentaPlusvalia().getCodigo());
			}
			dto.setGastosNotaria(condiciones.getGastosNotaria());
			if(!Checks.esNulo(condiciones.getTipoPorCuentaNotaria())){
				dto.setNotariaPorCuentaDe(condiciones.getTipoPorCuentaNotaria().getCodigo());
			}
			dto.setGastosOtros(condiciones.getGastosOtros());
			if(!Checks.esNulo(condiciones.getTipoPorCuentaGastosOtros())){
				dto.setGastosCompraventaOtrosPorCuentaDe(condiciones.getTipoPorCuentaGastosOtros().getCodigo());
			}
			
			//Economicas-Gastos Alquiler
			dto.setGastosIbi(condiciones.getGastosIbi());
			if(!Checks.esNulo(condiciones.getTipoPorCuentaIbi())){
				dto.setIbiPorCuentaDe(condiciones.getTipoPorCuentaIbi().getCodigo());
			}
			dto.setGastosComunidad(condiciones.getGastosComunidad());
			if(!Checks.esNulo(condiciones.getTipoPorCuentaComunidadAlquiler())){
				dto.setComunidadPorCuentaDe(condiciones.getTipoPorCuentaComunidadAlquiler().getCodigo());
			}
			dto.setGastosSuministros(condiciones.getGastosSuministros());
			if(!Checks.esNulo(condiciones.getTipoPorCuentaSuministros())){
				dto.setSuministrosPorCuentaDe(condiciones.getTipoPorCuentaSuministros().getCodigo());
			}
			
			//Economicas-Cargas pendientes
			dto.setImpuestos(condiciones.getCargasImpuestos());
			if(!Checks.esNulo(condiciones.getTipoPorCuentaImpuestos())){
				dto.setImpuestosPorCuentaDe(condiciones.getTipoPorCuentaImpuestos().getCodigo());
			}
			dto.setComunidades(condiciones.getCargasComunidad());
			if(!Checks.esNulo(condiciones.getTipoPorCuentaComunidad())){
				dto.setComunidadesPorCuentaDe(condiciones.getTipoPorCuentaComunidad().getCodigo());
			}
			dto.setCargasOtros(condiciones.getCargasOtros());
			if(!Checks.esNulo(condiciones.getTipoPorCuentaCargasOtros())){
				dto.setCargasPendientesOtrosPorCuentaDe(condiciones.getTipoPorCuentaCargasOtros().getCodigo());
			}
			
			//Juridicas-situacion del activo
			dto.setSujetoTramiteTanteo(condiciones.getSujetoTanteoRetracto());
			dto.setEstadoTramite(condiciones.getEstadoTramite());
			
			//Juridicas-Requerimientos del comprador
			if(!Checks.esNulo(condiciones.getEstadoTitulo())){
				dto.setEstadoTituloCodigo(condiciones.getEstadoTitulo().getCodigo());
			}
			dto.setPosesionInicial((condiciones.getPosesionInicial()));
			if(!Checks.esNulo(condiciones.getSituacionPosesoria())){
				dto.setSituacionPosesoriaCodigo(condiciones.getSituacionPosesoria().getCodigo());
			}
			
			dto.setRenunciaSaneamientoEviccion(condiciones.getRenunciaSaneamientoEviccion());
			dto.setRenunciaSaneamientoVicios(condiciones.getRenunciaSaneamientoVicios());
			
			//Condicionantes administrativos
			dto.setProcedeDescalificacion(condiciones.getProcedeDescalificacion());
			if(!Checks.esNulo(condiciones.getTipoPorCuentaDescalificacion())){
				dto.setProcedeDescalificacionPorCuentaDe(condiciones.getTipoPorCuentaDescalificacion().getCodigo());
			}
			dto.setLicencia(condiciones.getLicencia());
			if(!Checks.esNulo(condiciones.getTipoPorCuentaLicencia())){
				dto.setLicenciaPorCuentaDe(condiciones.getTipoPorCuentaLicencia().getCodigo());
			}
		}
		
		return dto;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveCondicionesExpediente(DtoCondiciones dto, Long idExpediente){
		
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		CondicionanteExpediente condiciones = expedienteComercial.getCondicionante();
		
		if(!Checks.esNulo(condiciones)){
			//condiciones.setExpediente(expedienteComercial);
			condiciones= dtoCondicionantestoCondicionante(condiciones, dto);
		}
		
		else{	
			condiciones= new CondicionanteExpediente();
			condiciones.setExpediente(expedienteComercial);
			condiciones= dtoCondicionantestoCondicionante(condiciones, dto);		
		}
		
		genericDao.save(CondicionanteExpediente.class, condiciones);
		
		Reserva reserva = expedienteComercial.getReserva();
		
		// Creamos la reserva si se existe en condiciones y no se ha creado todavia
		if(!Checks.esNulo(condiciones.getTipoCalculoReserva()) && Checks.esNulo(reserva)) {
			reserva = new Reserva();
			DDEstadosReserva estadoReserva = (DDEstadosReserva) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosReserva.class, DDEstadosReserva.CODIGO_PENDIENTE_FIRMA);
			reserva.setEstadoReserva(estadoReserva);
			reserva.setExpediente(expedienteComercial);
			reserva.setNumReserva(reservaDao.getNextNumReservaRem());
			
			genericDao.save(Reserva.class, reserva);
		} else {
			
		}
		
		return true;
		
	}
	
	public CondicionanteExpediente dtoCondicionantestoCondicionante(CondicionanteExpediente condiciones, DtoCondiciones dto){
		try{
			
			beanUtilNotNull.copyProperties(condiciones, dto); 
			
			if(!Checks.esNulo(dto.getEstadosFinanciacion())){
				DDEstadoFinanciacion estadoFinanciacion = (DDEstadoFinanciacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoFinanciacion.class, dto.getEstadosFinanciacion());
				condiciones.setEstadoFinanciacion(estadoFinanciacion);
			}
			//Reserva
			if(dto.getTipoCalculo()!=null){
				DDTipoCalculo tipoCalculo= (DDTipoCalculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCalculo.class, dto.getTipoCalculo());
				if(!Checks.esNulo(tipoCalculo)){
					condiciones.setTipoCalculoReserva(tipoCalculo);
				}else{
					condiciones.setTipoCalculoReserva(null);
					condiciones.setPorcentajeReserva(null);
					condiciones.setImporteReserva(null);
					condiciones.setPlazoFirmaReserva(null);
				}
			}
			
			//Fiscales
			if(!Checks.esNulo(dto.getTipoImpuestoCodigo())){
				DDTiposImpuesto tipoImpuesto= (DDTiposImpuesto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposImpuesto.class, dto.getTipoImpuestoCodigo());
				condiciones.setTipoImpuesto(tipoImpuesto);
			}
			
			//Gastos CompraVenta
			if(!Checks.esNulo(dto.getPlusvaliaPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaPlusvalia= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getPlusvaliaPorCuentaDe());
				condiciones.setTipoPorCuentaPlusvalia(tipoPorCuentaPlusvalia);
			}
			if(!Checks.esNulo(dto.getNotariaPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaNotaria= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getNotariaPorCuentaDe());
				condiciones.setTipoPorCuentaNotaria(tipoPorCuentaNotaria);
			}
			if(!Checks.esNulo(dto.getGastosCompraventaOtrosPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaGCVOtros= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getGastosCompraventaOtrosPorCuentaDe());
				condiciones.setTipoPorCuentaGastosOtros(tipoPorCuentaGCVOtros);
			}
			
			//Gastos Alquiler
			if(!Checks.esNulo(dto.getIbiPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaIbi= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getIbiPorCuentaDe());
				condiciones.setTipoPorCuentaIbi(tipoPorCuentaIbi);
			}
			if(!Checks.esNulo(dto.getComunidadPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaComunidad= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getComunidadPorCuentaDe());
				condiciones.setTipoPorCuentaComunidadAlquiler(tipoPorCuentaComunidad);
			}
			if(!Checks.esNulo(dto.getSuministrosPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaSuministros= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getSuministrosPorCuentaDe());
				condiciones.setTipoPorCuentaSuministros(tipoPorCuentaSuministros);
			}
			
			//Cargas pendientes
			if(!Checks.esNulo(dto.getImpuestosPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaImpuestos= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getImpuestosPorCuentaDe());
				condiciones.setTipoPorCuentaImpuestos(tipoPorCuentaImpuestos);
			}
			if(!Checks.esNulo(dto.getComunidadesPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaComunidad= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getComunidadesPorCuentaDe());
				condiciones.setTipoPorCuentaComunidad(tipoPorCuentaComunidad);
			}
			if(!Checks.esNulo(dto.getCargasPendientesOtrosPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaCPOtros= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getCargasPendientesOtrosPorCuentaDe());
				condiciones.setTipoPorCuentaCargasOtros(tipoPorCuentaCPOtros);
			}
	
			//Requerimientos del comprador
			if(!Checks.esNulo(dto.getEstadoTituloCodigo())){
				DDEstadoTitulo estadoTitulo= (DDEstadoTitulo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoTitulo.class, dto.getEstadoTituloCodigo());
				condiciones.setEstadoTitulo(estadoTitulo);
			}
			if(dto.getSituacionPosesoriaCodigo()!=null){
				DDSituacionesPosesoria situacionPosesoria= (DDSituacionesPosesoria) utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionesPosesoria.class, dto.getSituacionPosesoriaCodigo());
				if(!Checks.esNulo(situacionPosesoria)){
					condiciones.setSituacionPosesoria(situacionPosesoria);
				}else{
					condiciones.setSituacionPosesoria(null);
				}
			}
			
			//Renuncia a saneamiento por

			//Condiciones administrativas
			if(!Checks.esNulo(dto.getProcedeDescalificacionPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaDescalificacion= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getProcedeDescalificacionPorCuentaDe());
				condiciones.setTipoPorCuentaDescalificacion(tipoPorCuentaDescalificacion);
			}
			
			if(!Checks.esNulo(dto.getLicenciaPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaLicencia= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getLicenciaPorCuentaDe());
				condiciones.setTipoPorCuentaLicencia(tipoPorCuentaLicencia);
			}
		}catch(Exception ex) {
			logger.error(ex.getMessage());
			return condiciones;
		}
		
		return condiciones;
	}
	
	public DtoPage getPosicionamientosExpediente(Long idExpediente){
		
		ExpedienteComercial expediente= findOne(idExpediente);
		
		List<Posicionamiento> listaPosicionamientos= expediente.getPosicionamientos();
		List<DtoPosicionamiento> posicionamientos = new ArrayList<DtoPosicionamiento>();
		
		for(Posicionamiento posicionamiento: listaPosicionamientos){
			DtoPosicionamiento posicionamientoDto= posicionamientoToDto(posicionamiento);
			posicionamientos.add(posicionamientoDto);
		}
		
		return new DtoPage(posicionamientos, posicionamientos.size());
		
		
	}
	
	public DtoPosicionamiento posicionamientoToDto(Posicionamiento posicionamiento){
		
		DtoPosicionamiento posicionamientoDto= new DtoPosicionamiento();
		posicionamientoDto.setFechaAviso(posicionamiento.getFechaAviso());
		posicionamientoDto.setNotaria(posicionamiento.getNotaria());
		posicionamientoDto.setFechaPosicionamiento(posicionamiento.getFechaPosicionamiento());
		posicionamientoDto.setMotivoAplazamiento(posicionamiento.getMotivoAplazamiento());
		
		return posicionamientoDto;
		
	}
	
	public DtoPage getComparecientesExpediente(Long idExpediente){
		
		//ExpedienteComercial expediente= findOne(idExpediente);
		List<ComparecienteVendedor> listaComparecientes= new ArrayList<ComparecienteVendedor>();
		List<DtoComparecienteVendedor> comparecientes= new ArrayList<DtoComparecienteVendedor>();
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		listaComparecientes= genericDao.getList(ComparecienteVendedor.class, filtro);
		
		for(ComparecienteVendedor compareciente: listaComparecientes){
			DtoComparecienteVendedor comparecienteDto= comparecienteToDto(compareciente);
			comparecientes.add(comparecienteDto);
		}
		
		return new DtoPage(comparecientes, comparecientes.size());
		
	}
	
	public DtoComparecienteVendedor comparecienteToDto(ComparecienteVendedor compareciente){
		DtoComparecienteVendedor comparecienteDto= new DtoComparecienteVendedor();
		comparecienteDto.setNombre(compareciente.getNombre());
		comparecienteDto.setDireccion((compareciente.getDireccion()));
		comparecienteDto.setTelefono(compareciente.getEmail());
		comparecienteDto.setEmail((compareciente.getEmail()));
		comparecienteDto.setTipoCompareciente(compareciente.getTipoCompareciente().getDescripcion());
		
		return comparecienteDto;

	}
	
	public DtoPage getSubsanacionesExpediente(Long idExpediente){
		
		//ExpedienteComercial expediente= findOne(idExpediente);
		List<Subsanaciones> listaSubsanaciones= new ArrayList<Subsanaciones>();
		List<DtoSubsanacion> subsanaciones= new ArrayList<DtoSubsanacion>();
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		listaSubsanaciones= genericDao.getList(Subsanaciones.class, filtro);
		
		for(Subsanaciones subsanacion: listaSubsanaciones){
			DtoSubsanacion subsanacionDto= subsanacionToDto(subsanacion);
			subsanaciones.add(subsanacionDto);
		}
		
		return new DtoPage(subsanaciones, subsanaciones.size());
		
	}
	
	public DtoSubsanacion subsanacionToDto(Subsanaciones subsanacion){
		DtoSubsanacion subsanacionDto= new DtoSubsanacion();
		subsanacionDto.setFechaPeticion(subsanacion.getFechaPeticion());
		subsanacionDto.setPeticionario(subsanacion.getPeticionario());
		subsanacionDto.setMotivo(subsanacion.getMotivo());
		subsanacionDto.setEstado(subsanacion.getEstado().getDescripcion());
		subsanacionDto.setGastosSubsanacion(subsanacion.getGastosSubsanacion());
		subsanacionDto.setGastosInscripcion(subsanacion.getGastosInscripcion());
		
		return subsanacionDto;
	}
	
	public DtoPage getNotariosExpediente(Long idExpediente){
		ExpedienteComercial expediente= findOne(idExpediente);
		List<DtoActivoProveedorContacto> proveedoresContacto= new ArrayList<DtoActivoProveedorContacto>();
		
		if(!Checks.esNulo(expediente.getTrabajo())){
			ActivoProveedorContacto proveedorContacto= expediente.getTrabajo().getProveedorContacto();
			if(!Checks.esNulo(proveedorContacto)){
				proveedoresContacto.add(activoProveedorContactoToDto(proveedorContacto));
			}
		}
		
		return new DtoPage(proveedoresContacto, proveedoresContacto.size());
		
	}
	
	public DtoActivoProveedorContacto activoProveedorContactoToDto(ActivoProveedorContacto proveedorContacto){
		DtoActivoProveedorContacto proveedorContactoDto= new DtoActivoProveedorContacto();
		String nombreCompleto= "";
		if(!Checks.esNulo(proveedorContacto.getNombre())){
			nombreCompleto= proveedorContacto.getNombre() + " ";
		}
		if(!Checks.esNulo(proveedorContacto.getApellido1())){
			nombreCompleto= nombreCompleto + proveedorContacto.getApellido1() + " ";
		}
		if(!Checks.esNulo(proveedorContacto.getApellido2())){
			nombreCompleto= nombreCompleto + proveedorContacto.getApellido2();
		}
		if(!Checks.esNulo(proveedorContacto.getProveedor())){
			proveedorContactoDto.setNombre(proveedorContacto.getProveedor().getNombre());
		}
		proveedorContactoDto.setPersonaContacto(nombreCompleto);
		proveedorContactoDto.setDireccion(proveedorContacto.getDireccion());

		//Falta cargo

		if(!Checks.esNulo(proveedorContacto.getTelefono1())){
			proveedorContactoDto.setTelefono(proveedorContacto.getTelefono1());
		}
		else{
			proveedorContactoDto.setTelefono(proveedorContacto.getTelefono2());
		}
		proveedorContactoDto.setEmail(proveedorContacto.getEmail());
		if(!Checks.esNulo(proveedorContacto.getProvincia())){
			proveedorContactoDto.setProvincia(proveedorContacto.getProvincia().getDescripcion());
		}
		if(!Checks.esNulo(proveedorContacto.getTipoDocIdentificativo())){
			proveedorContactoDto.setTipoDocIdentificativo(proveedorContacto.getTipoDocIdentificativo().getDescripcion());
		}
		proveedorContactoDto.setDocIdentificativo(proveedorContacto.getDocIdentificativo());
		proveedorContactoDto.setCodigoPostal(proveedorContacto.getCodigoPostal());
		proveedorContactoDto.setFax(proveedorContacto.getFax());
		proveedorContactoDto.setTelefono2(proveedorContacto.getTelefono2());
		
		
		return proveedorContactoDto;
		
	}
	
	public DtoFormalizacionResolucion expedienteToDtoFormalizacion(ExpedienteComercial expediente){
		
		DtoFormalizacionResolucion formalizacionDto= new DtoFormalizacionResolucion();
		List<Formalizacion> listaResolucionFormalizacion= new ArrayList<Formalizacion>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId());
		listaResolucionFormalizacion= genericDao.getList(Formalizacion.class, filtro);
		
		//Un expediente de venta solo puede tener una resolucion, en el extraño caso que tenga más de una elegimos la primera
		if(listaResolucionFormalizacion.size()>0){
			formalizacionDto= formalizacionToDto(listaResolucionFormalizacion.get(0));
		}
		
		return formalizacionDto;

	}
	
	public DtoFormalizacionResolucion formalizacionToDto(Formalizacion formalizacion){
		DtoFormalizacionResolucion resolucionDto= new DtoFormalizacionResolucion();
		
		resolucionDto.setPeticionario(formalizacion.getPeticionario());
		resolucionDto.setMotivoResolucion(formalizacion.getMotivoResolucion());
		resolucionDto.setGastosCargo(formalizacion.getGastosCargo());
		resolucionDto.setFormaPago(formalizacion.getFormaPago());
		resolucionDto.setFechaPeticion(formalizacion.getFechaPeticion());
		resolucionDto.setFechaResolucion(formalizacion.getFechaResolucion());
		resolucionDto.setImporte(formalizacion.getImporte());
		resolucionDto.setFechaPago(formalizacion.getFechaPago());
		
		return resolucionDto;
	}

	public DtoPage getGastosSoportadoPropietario(Long idExpediente) {
		List<DtoGastoExpediente> gastosExpediente= new ArrayList<DtoGastoExpediente>();
		DtoGastoExpediente gastoExpedienteDto= new DtoGastoExpediente();
		
		//Falta la busqueda de los gastos y añadir un el dto a la lista de dto's
		
		return new DtoPage(gastosExpediente, gastosExpediente.size());
	}
	
	public DtoPage getGastosSoportadoHaya(Long idExpediente) {
		List<DtoGastoExpediente> gastosExpediente= new ArrayList<DtoGastoExpediente>();
		DtoGastoExpediente gastoExpedienteDto= new DtoGastoExpediente();
		
		//Falta la busqueda de los gastos y añadir un el dto a la lista de dto's
		
		return new DtoPage(gastosExpediente, gastosExpediente.size());
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveReserva(DtoReserva dto, Long idExpediente) {
		
		ExpedienteComercial expediente= findOne(idExpediente);
		Reserva reserva = expediente.getReserva();
		

		if(!Checks.esNulo(dto.getTipoArrasCodigo())) {
			
			DDTiposArras tipoArras = (DDTiposArras) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposArras.class, dto.getTipoArrasCodigo());
			reserva.setTipoArras(tipoArras);
		}
		
		genericDao.save(Reserva.class, reserva);
		
		return true;
	}
	
	public DtoPage getHonorarios(Long idExpediente) {
		List<DtoGastoExpediente> gastosExpediente= new ArrayList<DtoGastoExpediente>();
		DtoGastoExpediente gastoExpedienteDto= new DtoGastoExpediente();
		
		//Falta la busqueda de los gastos y añadir un el dto a la lista de dto's
		
		return new DtoPage(gastosExpediente, gastosExpediente.size());
	}
	

}
