package es.pfsgroup.plugin.rem.expedienteComercial;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoDatosBasicosOferta;
import es.pfsgroup.plugin.rem.model.DtoEntregaReserva;
import es.pfsgroup.plugin.rem.model.DtoFichaExpediente;
import es.pfsgroup.plugin.rem.model.DtoReserva;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.TextosOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoFinanciacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.model.dd.DDTiposTextoOferta;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;


@Service("expedienteComercialManager")
public class ExpedienteComercialManager implements ExpedienteComercialApi {
	
	protected static final Log logger = LogFactory.getLog(ExpedienteComercialManager.class);
	
	public final String PESTANA_FICHA = "ficha";
	public final String PESTANA_DATOSBASICOS_OFERTA = "datosbasicosoferta";
	public final String PESTANA_RESERVA = "reserva";
	public final String PESTANA_CONDICIONES = "condiciones";

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private OfertaDao ofertaDao;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	private  BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
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
					dto.setTieneReserva(expediente.getCondicionante().getImporteReserva() != null);
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
			dto.setFechaEvio(reserva.getFechaEnvio());
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
			dto.setEstadoTituloCodigo(condiciones.getEstadoTitulo().getCodigo());
			dto.setPosesionInical(condiciones.getPosesionInicial());
			dto.setSituacionPosesoriaCodigo(condiciones.getSituacionPosesoria().getCodigo());
			
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
			condiciones.setExpediente(expedienteComercial);
			condiciones= dtoCondicionantestoCondicionante(condiciones, dto);
		}
		
		else{	
			condiciones= new CondicionanteExpediente();
			condiciones.setExpediente(expedienteComercial);
			condiciones= dtoCondicionantestoCondicionante(condiciones, dto);		
		}
		
		genericDao.save(CondicionanteExpediente.class, condiciones);
		return true;
		
	}
	
	public CondicionanteExpediente dtoCondicionantestoCondicionante(CondicionanteExpediente condiciones, DtoCondiciones dto){
		try{
			
			beanUtilNotNull.copyProperties(condiciones, dto);
			
			//condiciones.setSolicitaFinanciacion(dto.getSolicitaFinanciacion());
			//condiciones.setEntidadFinanciacion(dto.getEntidadFinanciacion());
			
			if(!Checks.esNulo(dto.getEstadosFinanciacion())){
				DDEstadoFinanciacion estadoFinanciacion = (DDEstadoFinanciacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoFinanciacion.class, dto.getEstadosFinanciacion());
				condiciones.setEstadoFinanciacion(estadoFinanciacion);
			}
			//Reserva
			if(!Checks.esNulo(dto.getTipoCalculo())){
				DDTipoCalculo tipoCalculo= (DDTipoCalculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCalculo.class, dto.getTipoCalculo());
				condiciones.setTipoCalculoReserva(tipoCalculo);
			}
			//condiciones.setPorcentajeReserva(dto.getPorcentajeReserva());
			//condiciones.setPlazoFirmaReserva(dto.getPlazoFirmaReserva());
			//condiciones.setImporteReserva(dto.getImporteReserva());
			
			//Fiscales
			if(!Checks.esNulo(dto.getTipoImpuestoCodigo())){
				DDTiposImpuesto tipoImpuesto= (DDTiposImpuesto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposImpuesto.class, dto.getTipoImpuestoCodigo());
				condiciones.setTipoImpuesto(tipoImpuesto);
			}
			//condiciones.setTipoAplicable(dto.getTipoAplicable());
			
//			if(!Checks.esNulo(dto.getRenunciaExencion())){
//				if(dto.getRenunciaExencion().equals(true)){
//					condiciones.setRenunciaExencion(1);
//				}else if(dto.getRenunciaExencion().equals(false)){
//					condiciones.setRenunciaExencion(0);
//				}
//			}
//			
//			if(!Checks.esNulo(dto.getReservaConImpuesto())){
//				if(dto.getReservaConImpuesto().equals(true)){
//					condiciones.setReservaConImpuesto(1);
//				}else if(dto.getRenunciaExencion().equals(false)){
//					condiciones.setReservaConImpuesto(0);
//				}
//			}
			
			//Gastos compraventa
			//condiciones.setGastosPlusvalia(dto.getGastosPlusvalia());
			//condiciones.setGastosNotaria(dto.getGastosNotaria());
			//condiciones.setGastosOtros(dto.getGastosOtros());
			
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
			
			//Cargas pendientes
			//condiciones.setCargasOtros(dto.getCargasOtros());
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
			if(!Checks.esNulo(dto.getSituacionPosesoriaCodigo())){
				DDSituacionesPosesoria situacionPosesoria= (DDSituacionesPosesoria) utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionesPosesoria.class, dto.getSituacionPosesoriaCodigo());
				condiciones.setSituacionPosesoria(situacionPosesoria);
			}
			
			//Renuncia a saneamiento por
			//condiciones.setRenunciaSaneamientoEviccion(dto.getRenunciaSaneamientoEviccion());
			//condiciones.setRenunciaSaneamientoVicios(dto.getRenunciaSaneamientoVicios());
			
			//Condiciones administrativas
			//condiciones.setProcedeDescalificacion(dto.getProcedeDescalificacion());
			if(!Checks.esNulo(dto.getProcedeDescalificacionPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaDescalificacion= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getProcedeDescalificacionPorCuentaDe());
				condiciones.setTipoPorCuentaDescalificacion(tipoPorCuentaDescalificacion);
			}
			//condiciones.setLicencia(dto.getLicencia());
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

}
