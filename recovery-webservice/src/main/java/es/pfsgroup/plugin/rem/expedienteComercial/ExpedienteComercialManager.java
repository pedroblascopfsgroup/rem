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
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
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
		
		if(!Checks.esNulo(condiciones)) {			
			dto.setSolicitaFinanciacion(condiciones.getSolicitaFinanciacion());
		}
		
		return dto;
	}

}
