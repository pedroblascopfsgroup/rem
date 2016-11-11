package es.pfsgroup.plugin.rem.expedienteComercial;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.ComparecienteVendedor;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CompradorExpediente.CompradorExpedientePk;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.DtoActivosExpediente;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoExpediente;
import es.pfsgroup.plugin.rem.model.DtoClienteUrsus;
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
import es.pfsgroup.plugin.rem.model.DtoTanteoYRetractoOferta;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Formalizacion;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.ObservacionesExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Posicionamiento;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.Subsanaciones;
import es.pfsgroup.plugin.rem.model.TextosOferta;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDCanalPrescripcion;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDevolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoFinanciacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedorHonorario;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;
import es.pfsgroup.plugin.rem.model.dd.DDTiposDocumentos;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.model.dd.DDTiposTextoOferta;
import es.pfsgroup.plugin.rem.reserva.dao.ReservaDao;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDataDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaUVEMDto;
import es.pfsgroup.plugin.rem.rest.dto.ResultadoInstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularUVEMDto;

@Service("expedienteComercialManager")
public class ExpedienteComercialManager implements ExpedienteComercialApi {
	
	protected static final Log logger = LogFactory.getLog(ExpedienteComercialManager.class);
	
	public final String PESTANA_FICHA = "ficha";
	public final String PESTANA_DATOSBASICOS_OFERTA = "datosbasicosoferta";
	public final String PESTANA_TANTEO_Y_RETRACTO_OFERTA= "ofertatanteoyretracto";
	public final String PESTANA_RESERVA = "reserva";
	public final String PESTANA_CONDICIONES = "condiciones";
	public final String PESTANA_FORMALIZACION= "formalizacion";

	
	//Textos a mostrar por defecto
	public static final String TANTEO_CONDICIONES_TRANSMISION = "msg.defecto.oferta.tanteo.condiciones.transmision";

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ReservaDao reservaDao;
	
	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;
	
	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Autowired
	private UvemManagerApi uvemManagerApi;
	
	@Resource
    MessageService messageServices;

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
			} else if(PESTANA_TANTEO_Y_RETRACTO_OFERTA.equals(tab)){
				dto = expedienteToDtoTanteoYRetractoOferta(expediente);
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
		
		if(!Checks.esNulo(dto.getEstadoCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoCodigo());
			DDEstadoOferta estado = genericDao.get(DDEstadoOferta.class, filtro);	
			oferta.setEstadoOferta(estado);;	
		}
		
		if(!Checks.esNulo(dto.getTipoOfertaCodigo())){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoOfertaCodigo());
			DDTipoOferta tipoOferta = genericDao.get(DDTipoOferta.class, filtro);	
			oferta.setTipoOferta(tipoOferta);
		}
		
		if(!Checks.esNulo(dto.getEstadoVisitaOfertaCodigo())){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoVisitaOfertaCodigo());
			DDEstadosVisitaOferta estadoVisitaOferta = genericDao.get(DDEstadosVisitaOferta.class, filtro);	
			oferta.setEstadoVisitaOferta(estadoVisitaOferta);
		}
		
		if(!Checks.esNulo(dto.getCanalPrescripcionCodigo())){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCanalPrescripcionCodigo());
			DDCanalPrescripcion canalPrescripcion = genericDao.get(DDCanalPrescripcion.class, filtro);	
			oferta.setCanalPrescripcion(canalPrescripcion);
		}
		if(("").equals(dto.getCanalPrescripcionCodigo())){
			oferta.setCanalPrescripcion(null);
		}
		
		if(!Checks.esNulo(dto.getComitePropuestoCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",dto.getComitePropuestoCodigo());
			DDComiteSancion comitePropuesto = genericDao.get(DDComiteSancion.class, filtro);	
			expedienteComercial.setComitePropuesto(comitePropuesto);			
		}
		
		if(!Checks.esNulo(dto.getComiteSancionadorCodigo())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",dto.getComiteSancionadorCodigo());
			DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filtro);	
			expedienteComercial.setComiteSancion(comiteSancion);			
		}
		
		if(!Checks.esNulo(dto.getNumVisita())){
			Filter filtroVisita = genericDao.createFilter(FilterType.EQUALS, "numVisitaRem",dto.getNumVisita());
			Visita visita = genericDao.get(Visita.class, filtroVisita);

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expedienteComercial.getId());	
			List<GastosExpediente> lista = (List<GastosExpediente>) genericDao.getList(GastosExpediente.class, filtro);
			
			if(!Checks.esNulo(visita)){
				oferta.setVisita(visita);
				
				DDEstadosVisitaOferta estadoVisitaOferta= (DDEstadosVisitaOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosVisitaOferta.class, DDEstadosVisitaOferta.ESTADO_VISITA_OFERTA_REALIZADA);
				oferta.setEstadoVisitaOferta(estadoVisitaOferta);
				
				if(!Checks.esNulo(visita.getApiCustodio()) && Checks.esNulo(oferta.getCustodio())){ //si la visita tiene custodio y la oferta no, lo copiamos
					oferta.setCustodio(visita.getApiCustodio());
					GastosExpediente gastoNuevo= new GastosExpediente();
					DDAccionGastos accionGasto= (DDAccionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_COLABORACION);
					Filter filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo", visita.getApiCustodio().getTipoProveedor().getCodigo());	
					DDTipoProveedorHonorario tipoProveedor = genericDao.get(DDTipoProveedorHonorario.class, filtroTipoProveedor);
					gastoNuevo.setAccionGastos(accionGasto);
					gastoNuevo.setExpediente(expedienteComercial);
					gastoNuevo.setProveedor(visita.getApiCustodio());
					gastoNuevo.setTipoProveedor(tipoProveedor);
					genericDao.save(GastosExpediente.class, gastoNuevo);
					
					
				}
				else if(!Checks.esNulo(visita.getApiCustodio()) && !Checks.esNulo(oferta.getCustodio())){ //si la visita tiene custodio y la oferta tambien, si son diferentes lo borramos de los honorarios
					if(!visita.getApiCustodio().getId().equals(oferta.getCustodio().getId())){
						for(GastosExpediente gasto: lista){
							if(gasto.getAccionGastos().getCodigo().equals(DDAccionGastos.CODIGO_COLABORACION)){
								genericDao.deleteById(GastosExpediente.class, gasto.getId());
							}
						}
					}
				}

				if(!Checks.esNulo(visita.getApiResponsable()) && Checks.esNulo(oferta.getApiResponsable())){ //si la visita tiene custodio y la oferta no, lo copiamos
					oferta.setApiResponsable(visita.getApiResponsable());
					GastosExpediente gastoNuevo= new GastosExpediente();
					DDAccionGastos accionGasto= (DDAccionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE);
					Filter filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo", visita.getApiResponsable().getTipoProveedor().getCodigo());	
					DDTipoProveedorHonorario tipoProveedor = genericDao.get(DDTipoProveedorHonorario.class, filtroTipoProveedor);
					gastoNuevo.setAccionGastos(accionGasto);
					gastoNuevo.setExpediente(expedienteComercial);
					gastoNuevo.setProveedor(visita.getApiResponsable());
					gastoNuevo.setTipoProveedor(tipoProveedor);
					genericDao.save(GastosExpediente.class, gastoNuevo);
				}
				else if(!Checks.esNulo(visita.getApiResponsable()) && !Checks.esNulo(oferta.getApiResponsable())){ //si la visita tiene custodio y la oferta tambien, si son diferentes lo borramos de los honorarios
					if(!visita.getApiResponsable().getId().equals(oferta.getApiResponsable().getId())){
						for(GastosExpediente gasto: lista){
							if(gasto.getAccionGastos().getCodigo().equals(DDAccionGastos.CODIGO_RESPONSABLE_CLIENTE)){
								genericDao.deleteById(GastosExpediente.class, gasto.getId());
							}
						}
					}
				}
				if(!Checks.esNulo(visita.getFdv()) && Checks.esNulo(oferta.getFdv())){ //si la visita tiene custodio y la oferta no, lo copiamos
					oferta.setFdv(visita.getFdv());
					GastosExpediente gastoNuevo= new GastosExpediente();
					DDAccionGastos accionGasto= (DDAccionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_COLABORACION);
					Filter filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo", visita.getFdv().getTipoProveedor().getCodigo());	
					DDTipoProveedorHonorario tipoProveedor = genericDao.get(DDTipoProveedorHonorario.class, filtroTipoProveedor);
					gastoNuevo.setAccionGastos(accionGasto);
					gastoNuevo.setExpediente(expedienteComercial);
					gastoNuevo.setProveedor(visita.getFdv());
					gastoNuevo.setTipoProveedor(tipoProveedor);
					genericDao.save(GastosExpediente.class, gastoNuevo);
				}
				else if(!Checks.esNulo(visita.getFdv()) && !Checks.esNulo(oferta.getFdv())){ //si la visita tiene custodio y la oferta tambien, si son diferentes lo borramos de los honorarios
					if(!visita.getFdv().getId().equals(oferta.getFdv().getId())){
						for(GastosExpediente gasto: lista){
							if(gasto.getAccionGastos().getCodigo().equals(DDAccionGastos.CODIGO_COLABORACION)){
								genericDao.deleteById(GastosExpediente.class, gasto.getId());
							}
						}
					}
				}
				if(!Checks.esNulo(visita.getPrescriptor()) && Checks.esNulo(oferta.getPrescriptor())){ //si la visita tiene custodio y la oferta no, lo copiamos
					oferta.setPrescriptor(visita.getPrescriptor());
					GastosExpediente gastoNuevo= new GastosExpediente();
					DDAccionGastos accionGasto= (DDAccionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDAccionGastos.class, DDAccionGastos.CODIGO_PRESCRIPCION);
					Filter filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo", visita.getPrescriptor().getTipoProveedor().getCodigo());	
					DDTipoProveedorHonorario tipoProveedor = genericDao.get(DDTipoProveedorHonorario.class, filtroTipoProveedor);
					gastoNuevo.setAccionGastos(accionGasto);
					gastoNuevo.setExpediente(expedienteComercial);
					gastoNuevo.setProveedor(visita.getPrescriptor());
					gastoNuevo.setTipoProveedor(tipoProveedor);
					genericDao.save(GastosExpediente.class, gastoNuevo);
				}
				else if(!Checks.esNulo(visita.getPrescriptor()) && !Checks.esNulo(oferta.getPrescriptor())){ //si la visita tiene custodio y la oferta tambien, si son diferentes lo borramos de los honorarios
					if(!visita.getPrescriptor().getId().equals(oferta.getPrescriptor().getId())){
						for(GastosExpediente gasto: lista){
							if(gasto.getAccionGastos().getCodigo().equals(DDAccionGastos.CODIGO_PRESCRIPCION)){
								genericDao.deleteById(GastosExpediente.class, gasto.getId());
							}
						}
					}
				}
				genericDao.save(Oferta.class, oferta);
			}
			
			else{
				throw new JsonViewerException("La visita no existe");
			}

		}
		
		try {
			beanUtilNotNull.copyProperties(oferta, dto);
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
//		oferta.setFechaAlta(dto.getFechaAlta());
//		oferta.setImporteOferta(dto.getImporteOferta());
//		oferta.setFechaNotificacion(dto.getFechaNotificacion());
//		oferta.setImporteContraOferta(dto.getImporteContraoferta());
		
		expedienteComercial.setOferta(oferta);
		
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		
		return true;
	}


	@Override
	@Transactional(readOnly = false)
	public boolean saveOfertaTanteoYRetracto(DtoTanteoYRetractoOferta dtoTanteoYRetractoOferta, Long idExpediente) {
	
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		Oferta oferta = null;
		
		if(!Checks.esNulo(expedienteComercial))
			oferta = expedienteComercial.getOferta();
		
		if(!Checks.esNulo(oferta)){
			try {
				
				beanUtilNotNull.copyProperties(oferta, dtoTanteoYRetractoOferta);
				
				if(!Checks.esNulo(dtoTanteoYRetractoOferta.getResultadoTanteoCodigo()))
					oferta.setResultadoTanteo((DDResultadoTanteo) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoTanteo.class, dtoTanteoYRetractoOferta.getResultadoTanteoCodigo()));
				
			} catch (IllegalAccessException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			}
		}
		
		genericDao.save(Oferta.class, oferta);
		
		return true;
		
	}
	
	private DtoFichaExpediente expedienteToDtoFichaExpediente(ExpedienteComercial expediente) {

		DtoFichaExpediente dto = new DtoFichaExpediente();
		Oferta oferta = null;
		Activo activo = null;
		Reserva reserva = null;

		if(!Checks.esNulo(expediente)) {
			reserva = expediente.getReserva();
			oferta = expediente.getOferta();

			if(!Checks.esNulo(oferta)) {
				activo = oferta.getActivoPrincipal();
			}

			dto.setId(expediente.getId());

			if(!Checks.esNulo(oferta) && !Checks.esNulo(activo)) {		

				dto.setNumExpediente(expediente.getNumExpediente());	
				if(!Checks.esNulo(activo.getCartera())) {
					dto.setEntidadPropietariaDescripcion(activo.getCartera().getDescripcion());
					dto.setEntidadPropietariaCodigo(activo.getCartera().getCodigo());
				}	

				if(!Checks.esNulo(oferta.getTipoOferta())) {
					dto.setTipoExpedienteDescripcion(oferta.getTipoOferta().getDescripcion());
					dto.setTipoExpedienteCodigo(oferta.getTipoOferta().getCodigo());
					
					if(DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
						dto.setImporte(!Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteContraOferta(): oferta.getImporteOferta());
						
					} else if(DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())) {
						dto.setImporte(oferta.getImporteOferta());
					}
					
				}
				
				dto.setPropietario(activo.getFullNamePropietario());		
				if(!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
					dto.setMediador(activo.getInfoComercial().getMediadorInforme().getNombre());
				}

				dto.setImporte(!Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteContraOferta(): oferta.getImporteOferta());
				
				if(!Checks.esNulo(expediente.getCompradorPrincipal())) {
					dto.setComprador(expediente.getCompradorPrincipal().getFullName());
				}

				if(!Checks.esNulo(expediente.getEstado())) {
					dto.setEstado(expediente.getEstado().getDescripcion());
					dto.setCodigoEstado(expediente.getEstado().getCodigo());
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
				if(!Checks.esNulo(reserva)) {
					if(!Checks.esNulo(reserva.getEstadoDevolucion())) {
						dto.setEstadoDevolucionCodigo(reserva.getEstadoDevolucion().getCodigo());
					}
				}
				dto.setPeticionarioAnulacion(expediente.getPeticionarioAnulacion());
				dto.setFechaContabilizacionPropietario(expediente.getFechaContabilizacionPropietario());
				dto.setFechaDevolucionEntregas(expediente.getFechaDevolucionEntregas());
				dto.setImporteDevolucionEntregas(expediente.getImporteDevolucionEntregas());

				if(!Checks.esNulo(expediente.getCondicionante())) {
					dto.setTieneReserva(expediente.getCondicionante().getTipoCalculoReserva() != null);

					Integer ocultar = expediente.getCondicionante().getSujetoTanteoRetracto();
					dto.setOcultarPestTanteoRetracto(!Checks.esNulo(ocultar) && ocultar == 1 ? false : true);
				}

				if(!Checks.esNulo(expediente.getFechaInicioAlquiler())){
					dto.setFechaInicioAlquiler(expediente.getFechaInicioAlquiler());
				}
				if(!Checks.esNulo(expediente.getFechaFinAlquiler())){
					dto.setFechaFinAlquiler(expediente.getFechaFinAlquiler());
				}
				if(!Checks.esNulo(expediente.getImporteRentaAlquiler())){
					dto.setImporteRentaAlquiler(expediente.getImporteRentaAlquiler());
				}
				if(!Checks.esNulo(expediente.getNumContratoAlquiler())){
					dto.setNumContratoAlquiler(expediente.getNumContratoAlquiler());
				}
				if(!Checks.esNulo(expediente.getFechaPlazoOpcionCompraAlquiler())){
					dto.setFechaPlazoOpcionCompraAlquiler(expediente.getFechaPlazoOpcionCompraAlquiler());
				}
				if(!Checks.esNulo(expediente.getPrimaOpcionCompraAlquiler())){
					dto.setPrimaOpcionCompraAlquiler(expediente.getPrimaOpcionCompraAlquiler());
				}
				if(!Checks.esNulo(expediente.getPrecioOpcionCompraAlquiler())){
					dto.setPrecioOpcionCompraAlquiler(expediente.getPrecioOpcionCompraAlquiler());
				}
				if(!Checks.esNulo(expediente.getCondicionesOpcionCompraAlquiler())){
					dto.setCondicionesOpcionCompraAlquiler(expediente.getCondicionesOpcionCompraAlquiler());
				}
				if(!Checks.esNulo(expediente.getConflictoIntereses())){
					dto.setConflictoIntereses(expediente.getConflictoIntereses());
				}
				if(!Checks.esNulo(expediente.getRiesgoReputacional())){
					dto.setRiesgoReputacional(expediente.getRiesgoReputacional());
				}
				if(!Checks.esNulo(expediente.getEstadoPbc())){
					dto.setEstadoPbc(expediente.getEstadoPbc());
				}				
				if(!Checks.esNulo(expediente.getFechaVenta())){
					dto.setFechaVenta(expediente.getFechaVenta());
				}
				if(!Checks.esNulo(activo.getTipoComercializacion())){
					DDTipoComercializacion comercializacion = (DDTipoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, DDTipoComercializacion.CODIGO_ALQUILER_OPCION_COMPRA);
					if(comercializacion.equals(activo.getTipoComercializacion())){
						dto.setAlquilerOpcionCompra(1);
					}
					else{
						dto.setAlquilerOpcionCompra(0);
					}
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
			dto.setTipoOfertaCodigo(oferta.getTipoOferta().getCodigo());
		}
		dto.setFechaNotificacion(oferta.getFechaNotificacion());
		dto.setFechaAlta(oferta.getFechaAlta());
		if(!Checks.esNulo(oferta.getEstadoOferta())) {
			dto.setEstadoDescripcion(oferta.getEstadoOferta().getDescripcion());
			dto.setEstadoCodigo(oferta.getEstadoOferta().getCodigo());
		}
		if(!Checks.esNulo(oferta.getPrescriptor())) {
			dto.setPrescriptor(oferta.getPrescriptor().getNombre());
		}
		dto.setImporteOferta(oferta.getImporteOferta());
		dto.setImporteContraOferta(oferta.getImporteContraOferta());
		
		// TODO Comités sin definir
		//dto.setComite();
		
		if(!Checks.esNulo(oferta.getVisita())) {
			dto.setNumVisita(oferta.getVisita().getNumVisitaRem());
		}
		
		if(!Checks.esNulo(oferta.getEstadoVisitaOferta())) {
			dto.setEstadoVisitaOfertaCodigo(oferta.getEstadoVisitaOferta().getCodigo());
			dto.setEstadoVisitaOfertaDescripcion(oferta.getEstadoVisitaOferta().getDescripcion());
		}
		
		if(!Checks.esNulo(oferta.getCanalPrescripcion())){
			dto.setCanalPrescripcionCodigo(oferta.getCanalPrescripcion().getCodigo());
			dto.setCanalPrescripcionDescripcion(oferta.getCanalPrescripcion().getDescripcion());
		}
		
		if(!Checks.esNulo(expediente.getComitePropuesto())) {
			dto.setComitePropuestoCodigo(expediente.getComitePropuesto().getCodigo());
		}
		
		if(!Checks.esNulo(expediente.getComiteSancion())) {
			dto.setComiteSancionadorCodigo(expediente.getComiteSancion().getCodigo());
		}		
				
		return dto;
	}
	
	private DtoTanteoYRetractoOferta expedienteToDtoTanteoYRetractoOferta(ExpedienteComercial expediente) {

		DtoTanteoYRetractoOferta dtoTanteoYRetractoOferta = new DtoTanteoYRetractoOferta();
		Oferta oferta = null;
		
		if(!Checks.esNulo(expediente))
			oferta = expediente.getOferta();
		
		if(!Checks.esNulo(oferta)){
			try {
				
				beanUtilNotNull.copyProperties(dtoTanteoYRetractoOferta, oferta);
				dtoTanteoYRetractoOferta.setIdOferta(oferta.getId());
				
				if(!Checks.esNulo(oferta.getResultadoTanteo())){
					dtoTanteoYRetractoOferta.setResultadoTanteoCodigo(oferta.getResultadoTanteo().getCodigo());
					dtoTanteoYRetractoOferta.setResultadoTanteoDescripcion(oferta.getResultadoTanteo().getDescripcion());
				}
				
				if(Checks.esNulo(oferta.getCondicionesTransmision())) 
					dtoTanteoYRetractoOferta.setCondicionesTransmision(messageServices.getMessage(TANTEO_CONDICIONES_TRANSMISION));
				
			} catch (IllegalAccessException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			}
		}
	
		return dtoTanteoYRetractoOferta;
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
	@SuppressWarnings("unchecked")
	public DtoPage getListObservaciones(Long idExpediente, WebDto dto) {
				
		Page page = expedienteComercialDao.getObservacionesByExpediente(idExpediente, dto);
		

		List<DtoObservacion> observaciones = new ArrayList<DtoObservacion>();
		
		for (ObservacionesExpedienteComercial observacion: (List<ObservacionesExpedienteComercial>) page.getResults()) {
			
			DtoObservacion dtoObservacion = observacionToDto(observacion);
			observaciones.add(dtoObservacion);
		}
		
		return new DtoPage(observaciones,page.getTotalCount());
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
		Map<Long,Double> activoPorcentajeParti= new HashMap<Long, Double>();	
		Map<Long,Double> activoPrecioAprobado= new HashMap<Long, Double>();
		Map<Long,Double> activoPrecioMinimo= new HashMap<Long, Double>();
		Map<Long,Double> activoImporteParticipacion= new HashMap<Long, Double>();
		
		//Recorre los activos de la oferta y los añade a la lista de activos a mostrar
		for(ActivoOferta activoOferta: activosExpediente){
			listaActivosExpediente.add(activoOferta.getPrimaryKey().getActivo());
			if(!Checks.esNulo(activoOferta.getPorcentajeParticipacion())){
				activoPorcentajeParti.put(activoOferta.getPrimaryKey().getActivo().getId(),activoOferta.getPorcentajeParticipacion());
				if(!Checks.esNulo(activoOferta.getImporteActivoOferta())){
					activoImporteParticipacion.put(activoOferta.getPrimaryKey().getActivo().getId(), (activoOferta.getImporteActivoOferta()));
				}
			}
		}
		
		//Recorre la relacion activo-trabajo del expediente, por cada una guarda en un mapa el porcentaje de participacion del activo y el importe calculado a partir de dicho porcentaje
//		if(!Checks.esNulo(expediente.getTrabajo())){
//			for(ActivoTrabajo activoTrabajo: expediente.getTrabajo().getActivosTrabajo()){
//				activoPorcentajeParti.put(activoTrabajo.getPrimaryKey().getActivo().getId(), activoTrabajo.getParticipacion());
//				activoImporteParticipacion.put(activoTrabajo.getPrimaryKey().getActivo().getId(), 
//												(expediente.getOferta().getImporteOferta()*activoTrabajo.getParticipacion())/100);
//			}
//		}
		
		//Por cada activo recorre todas sus valoraciones para adquirir el precio aprobado de venta y el precio minimo autorizado
		for(Activo activo: listaActivosExpediente){
			for(ActivoValoraciones valoracion: activo.getValoracion()){
				if(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(valoracion.getTipoPrecio().getCodigo())){
					activoPrecioAprobado.put(activo.getId(), valoracion.getImporte());
				}
				if(DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO.equals(valoracion.getTipoPrecio().getCodigo())){
					activoPrecioMinimo.put(activo.getId(), valoracion.getImporte());
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
	private DtoActivosExpediente activosToDto(Activo activo, Map<Long,Double> activoPorcentajeParti, Map<Long,Double> activoPrecioAprobado, 
												Map<Long,Double> activoPrecioMinimo, Map<Long,Double> activoImporteParticipacion) {
		
		DtoActivosExpediente dtoActivo= new DtoActivosExpediente();
		
		try{
			dtoActivo.setIdActivo(activo.getId());
			dtoActivo.setNumActivo(activo.getNumActivo());
			dtoActivo.setSubtipoActivo(activo.getSubtipoActivo().getDescripcion());
			//Falta precio minimo y precio aprobado venta
			
			if(!Checks.estaVacio(activoPorcentajeParti)){
				dtoActivo.setPorcentajeParticipacion(activoPorcentajeParti.get(activo.getId()));
			}
			if(!Checks.estaVacio(activoPrecioAprobado)){
				dtoActivo.setPrecioAprobadoVenta(activoPrecioAprobado.get(activo.getId()));
			}
			if(!Checks.estaVacio(activoPrecioMinimo)){
				dtoActivo.setPrecioMinimo(activoPrecioMinimo.get(activo.getId()));
			}
			if(!Checks.estaVacio(activoImporteParticipacion)){
				dtoActivo.setImporteParticipacion((activoImporteParticipacion.get(activo.getId())));
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
	public Boolean comprobarExisteAdjuntoExpedienteComercial(Long idTrabajo, String codigoDocumento){
		Filter filtroTrabajoEC = genericDao.createFilter(FilterType.EQUALS, "expediente.trabajo.id", idTrabajo);
		Filter filtroAdjuntoSubtipoCodigo = genericDao.createFilter(FilterType.EQUALS, "subtipoDocumentoExpediente.codigo", codigoDocumento);
		AdjuntoExpedienteComercial adjuntoExpedienteComercial = genericDao.get(AdjuntoExpedienteComercial.class, filtroTrabajoEC, filtroAdjuntoSubtipoCodigo);
		
		if(!Checks.esNulo(adjuntoExpedienteComercial))
			return true;
		else
			return false;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public String upload(WebFileItem fileItem) throws Exception {

		//Subida de adjunto al Expediente Comercial
		ExpedienteComercial expediente = findOne(Long.parseLong(fileItem.getParameter("idEntidad")));
		
		ActivoAdjuntoActivo adjuntoActivo= null;
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
		
		for(ActivoOferta activoOferta: expediente.getOferta().getActivosOferta()){
			
			if(!Checks.esNulo(adjuntoExpediente) && !Checks.esNulo(adjuntoExpediente.getSubtipoDocumentoExpediente())
					&& !Checks.esNulo(adjuntoExpediente.getSubtipoDocumentoExpediente().getMatricula())){
				
				Activo activo= activoOferta.getPrimaryKey().getActivo();
				activoAdapter.uploadDocumento(fileItem, activo, adjuntoExpediente.getSubtipoDocumentoExpediente().getMatricula());
				adjuntoActivo= activo.getAdjuntos().get(activo.getAdjuntos().size()-1);
			}
		}
		
		if(!Checks.esNulo(adjuntoActivo)){
			adjuntoExpediente.setIdDocRestClient(adjuntoActivo.getIdDocRestClient());
			genericDao.update(AdjuntoExpedienteComercial.class, adjuntoExpediente);
		}
		
	        
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
	
	@Override
	public Page getCompradoresByExpediente(Long idExpediente, WebDto dto) {
		
		return expedienteComercialDao.getCompradoresByExpediente(idExpediente, dto);
	}
	
	@Override
	public VBusquedaDatosCompradorExpediente getDatosCompradorById(Long id) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id.toString());
		
		return genericDao.get(VBusquedaDatosCompradorExpediente.class, filtro);
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
			dto.setFechaInicioExpediente(condiciones.getFechaInicioExpediente());
			dto.setFechaInicioFinanciacion(condiciones.getFechaInicioFinanciacion());
			dto.setFechaFinFinanciacion(condiciones.getFechaFinFinanciacion());
			
			//Economicas-Reserva
			
			dto.setSolicitaReserva(condiciones.getSolicitaReserva());
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
			if(!Checks.esNulo(condiciones.getReservaConImpuesto())){
				if(condiciones.getReservaConImpuesto()==0){
					dto.setReservaConImpuesto(false);
				}
				else{
					dto.setReservaConImpuesto(true);
				}
			}						
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
			if(!Checks.esNulo(condiciones.getSujetoTanteoRetracto())) {
				dto.setSujetoTramiteTanteo(condiciones.getSujetoTanteoRetracto() == 1 ? true : false);
			}
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

		if(!Checks.esNulo(condiciones)) {
			//condiciones.setExpediente(expedienteComercial);
			condiciones= dtoCondicionantestoCondicionante(condiciones, dto);
		} else {	
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

			//Actualiza la disponibilidad comercial del activo
			ofertaApi.updateStateDispComercialActivosByOferta(expedienteComercial.getOferta());
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
					if(DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO.equals(tipoCalculo.getCodigo())){
						condiciones.setPorcentajeReserva(null);
					}
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
			if(!Checks.esNulo(dto.getReservaConImpuesto())){
				if(dto.getReservaConImpuesto()==false){
					condiciones.setReservaConImpuesto(0);
				}
				else{
					condiciones.setReservaConImpuesto(1);
				}
			}	

			//Gastos CompraVenta
			if(!Checks.esNulo(dto.getPlusvaliaPorCuentaDe()) || "".equals(dto.getPlusvaliaPorCuentaDe())){
				if("".equals(dto.getPlusvaliaPorCuentaDe())){
					condiciones.setGastosPlusvalia(null);
				}
				DDTiposPorCuenta tipoPorCuentaPlusvalia= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getPlusvaliaPorCuentaDe());
				condiciones.setTipoPorCuentaPlusvalia(tipoPorCuentaPlusvalia);
			}
			if(!Checks.esNulo(dto.getNotariaPorCuentaDe()) || "".equals(dto.getNotariaPorCuentaDe())){
				if("".equals(dto.getNotariaPorCuentaDe())){
					condiciones.setGastosNotaria(null);
				}
				DDTiposPorCuenta tipoPorCuentaNotaria= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getNotariaPorCuentaDe());
				condiciones.setTipoPorCuentaNotaria(tipoPorCuentaNotaria);
			}
			if(!Checks.esNulo(dto.getGastosCompraventaOtrosPorCuentaDe()) || "".equals(dto.getGastosCompraventaOtrosPorCuentaDe())){
				if("".equals(dto.getGastosCompraventaOtrosPorCuentaDe())){
					condiciones.setGastosOtros(null);
				}
				DDTiposPorCuenta tipoPorCuentaGCVOtros= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getGastosCompraventaOtrosPorCuentaDe());
				condiciones.setTipoPorCuentaGastosOtros(tipoPorCuentaGCVOtros);
			}
			
			//Gastos Alquiler
			if(!Checks.esNulo(dto.getIbiPorCuentaDe()) || "".equals(dto.getIbiPorCuentaDe())){
				if("".equals(dto.getIbiPorCuentaDe())){
					condiciones.setGastosIbi(null);
				}
				DDTiposPorCuenta tipoPorCuentaIbi= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getIbiPorCuentaDe());
				condiciones.setTipoPorCuentaIbi(tipoPorCuentaIbi);
			}
			if(!Checks.esNulo(dto.getComunidadPorCuentaDe()) || "".equals(dto.getComunidadPorCuentaDe())){
				if("".equals(dto.getComunidadPorCuentaDe())){
					condiciones.setGastosComunidad(null);
				}
				DDTiposPorCuenta tipoPorCuentaComunidad= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getComunidadPorCuentaDe());
				condiciones.setTipoPorCuentaComunidadAlquiler(tipoPorCuentaComunidad);
			}
			if(!Checks.esNulo(dto.getSuministrosPorCuentaDe()) || "".equals(dto.getSuministrosPorCuentaDe())){
				if("".equals(dto.getSuministrosPorCuentaDe())){
					condiciones.setGastosSuministros(null);
				}
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
			if(!Checks.esNulo(dto.getCargasPendientesOtrosPorCuentaDe()) || "".equals(dto.getCargasPendientesOtrosPorCuentaDe())){
				if("".equals(dto.getCargasPendientesOtrosPorCuentaDe())){
					condiciones.setCargasOtros(null);
				}
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
			if(!Checks.esNulo(dto.getProcedeDescalificacionPorCuentaDe()) || "".equals(dto.getProcedeDescalificacionPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaDescalificacion= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getProcedeDescalificacionPorCuentaDe());
				condiciones.setTipoPorCuentaDescalificacion(tipoPorCuentaDescalificacion);
			}
			
			if(!Checks.esNulo(dto.getLicenciaPorCuentaDe()) || "".equals(dto.getLicenciaPorCuentaDe())){
				DDTiposPorCuenta tipoPorCuentaLicencia= (DDTiposPorCuenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPorCuenta.class, dto.getLicenciaPorCuentaDe());
				condiciones.setTipoPorCuentaLicencia(tipoPorCuentaLicencia);
			}
			
			//Juridicas-situacion del activo
			if(!Checks.esNulo(dto.getSujetoTramiteTanteo())) {
				condiciones.setSujetoTanteoRetracto(dto.getSujetoTramiteTanteo() == true ? 1 : 0);
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
		posicionamientoDto.setIdPosicionamiento(posicionamiento.getId());
		posicionamientoDto.setFechaAviso(posicionamiento.getFechaAviso());
		if(!Checks.esNulo(posicionamiento.getNotario())) {
			posicionamientoDto.setIdProveedorNotario(posicionamiento.getNotario().getId());
		}
		posicionamientoDto.setFechaPosicionamiento(posicionamiento.getFechaPosicionamiento());
		posicionamientoDto.setMotivoAplazamiento(posicionamiento.getMotivoAplazamiento());
		
		return posicionamientoDto;
		
	}
	
	public Posicionamiento dtoToPosicionamiento(DtoPosicionamiento dto, Posicionamiento posicionamiento){
		
		posicionamiento.setFechaAviso(dto.getFechaAviso());
		if(!Checks.esNulo(dto.getIdProveedorNotario())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdProveedorNotario());
			ActivoProveedor notario = genericDao.get(ActivoProveedor.class, filtro);
			posicionamiento.setNotario(notario);
		}
		posicionamiento.setFechaPosicionamiento(dto.getFechaPosicionamiento());
		posicionamiento.setMotivoAplazamiento(dto.getMotivoAplazamiento());
		
		return posicionamiento;
		
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

		if(!Checks.esNulo(proveedorContacto.getCargoProveedorContacto())){
			proveedorContactoDto.setCargo(proveedorContacto.getCargoProveedorContacto().getDescripcion());
		}

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


	@Override
	@Transactional(readOnly = true)
	public ExpedienteComercial expedienteComercialPorOferta(Long idOferta) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", idOferta);
		ExpedienteComercial expC = genericDao.get(ExpedienteComercial.class, filtro);
		
		return expC;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean addEntregaReserva(EntregaReserva entregaReserva, Long idExpedienteComercial)throws Exception {
		
		ExpedienteComercial expedienteComercial = findOne(idExpedienteComercial);
		Reserva reserva = expedienteComercial.getReserva();
		if(reserva==null){
			throw new Exception("No existe la reserva para el expediente comercial");
		}
		entregaReserva.setReserva(reserva);
		
		try {
			genericDao.save(EntregaReserva.class, entregaReserva);
		} catch(Exception e) {
			return false;
		}
		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean update(ExpedienteComercial expedienteComercial) {
		try {
			genericDao.update(ExpedienteComercial.class, expedienteComercial);
		} catch(Exception e) {
			return false;
		}
		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveReserva(DtoReserva dto, Long idExpediente) {
		ExpedienteComercial expediente= findOne(idExpediente);
		Reserva reserva = expediente.getReserva();

		try {
			beanUtilNotNull.copyProperties(reserva, dto);
			if(!Checks.esNulo(dto.getTipoArrasCodigo())) {
				
				DDTiposArras tipoArras = (DDTiposArras) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposArras.class, dto.getTipoArrasCodigo());
				reserva.setTipoArras(tipoArras);
			}

			genericDao.save(Reserva.class, reserva);
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			return false;
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			return false;
		}

		return true;
	}
	
	public DtoPage getHonorarios(Long idExpediente) {
		List<DtoGastoExpediente> gastosExpedienteDto= new ArrayList<DtoGastoExpediente>();
		
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		List<GastosExpediente> gastosExpediente= genericDao.getList(GastosExpediente.class, filtro);
		
		//Añadir al dto
		for(GastosExpediente gasto: gastosExpediente){
			DtoGastoExpediente gastoExpedienteDto= new DtoGastoExpediente();
			if(!Checks.esNulo(gasto.getAccionGastos())){
				gastoExpedienteDto.setParticipacion(gasto.getAccionGastos().getDescripcion());
			}
			gastoExpedienteDto.setId(gasto.getId().toString());
			if(!Checks.esNulo(gasto.getProveedor())){
				gastoExpedienteDto.setProveedor(gasto.getProveedor().getNombre());
				gastoExpedienteDto.setIdProveedor(gasto.getProveedor().getId());
			}	
			if(!Checks.esNulo(gasto.getTipoProveedor())){
				gastoExpedienteDto.setTipoProveedor(gasto.getTipoProveedor().getDescripcion());
				gastoExpedienteDto.setCodigoTipoProveedor((gasto.getTipoProveedor().getCodigo()));
			}
			gastoExpedienteDto.setCodigoId((gasto.getCodigo()));
			if(!Checks.esNulo(gasto.getTipoCalculo())){
				gastoExpedienteDto.setTipoCalculo(gasto.getTipoCalculo().getDescripcion());
			}
			gastoExpedienteDto.setImporteCalculo(gasto.getImporteCalculo());
			gastoExpedienteDto.setHonorarios(gasto.getImporteFinal());
			gastoExpedienteDto.setObservaciones(gasto.getObservaciones());
			
			gastosExpedienteDto.add(gastoExpedienteDto);
		}
		

		//Falta la busqueda de los gastos y añadir un el dto a la lista de dto's
		
		return new DtoPage(gastosExpedienteDto, gastosExpedienteDto.size());
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveFichaComprador(VBusquedaDatosCompradorExpediente dto){
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId()));
		Comprador comprador = genericDao.get(Comprador.class, filtro);
		
		try{
			
			if(!Checks.esNulo(comprador)){
				
				if(!Checks.esNulo(dto.getNumeroClienteUrsus())){
					comprador.setIdCompradorUrsus(dto.getNumeroClienteUrsus());
				}
				
				if(!Checks.esNulo(dto.getCodTipoPersona())){
					DDTiposPersona tipoPersona = (DDTiposPersona) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPersona.class, dto.getCodTipoPersona());
					comprador.setTipoPersona(tipoPersona);
				}
				
				//Datos de identificación
				//Faltaria un campo para el apellido
				if(!Checks.esNulo(dto.getApellidos())){
					comprador.setApellidos(dto.getApellidos());
				}
				
				if(!Checks.esNulo(dto.getCodTipoDocumento())){
					DDTipoDocumento tipoDocumentoComprador = (DDTipoDocumento) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumento());
					comprador.setTipoDocumento(tipoDocumentoComprador);
				}
				if(!Checks.esNulo(dto.getNombreRazonSocial())){
				comprador.setNombre(dto.getNombreRazonSocial());
				}
				
				if(!Checks.esNulo(dto.getProvinciaCodigo())){
					DDProvincia provincia = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class, dto.getProvinciaCodigo());
					comprador.setProvincia(provincia);
				}
				
				if(!Checks.esNulo(dto.getMunicipioCodigo())){
					Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
					Localidad localidad = (Localidad) genericDao.get(Localidad.class, filtroLocalidad);
					comprador.setLocalidad(localidad);
				}
				if(!Checks.esNulo(dto.getCodigoPostal())){
					comprador.setCodigoPostal(dto.getCodigoPostal());
				}
				if(!Checks.esNulo(dto.getNumDocumento())){
					comprador.setDocumento(dto.getNumDocumento());
				}
				if(!Checks.esNulo(dto.getDireccion())){
					comprador.setDireccion(dto.getDireccion());
				}
				if(!Checks.esNulo(dto.getTelefono1())){
					comprador.setTelefono1(dto.getTelefono1());
				}
				if(!Checks.esNulo(dto.getTelefono2())){
					comprador.setTelefono2(dto.getTelefono2());
				}
				if(!Checks.esNulo(dto.getEmail())){
					comprador.setEmail(dto.getEmail());
				}
				
				Filter filtroExpedienteComercial = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getIdExpedienteComercial()));
				ExpedienteComercial expedienteComercial = genericDao.get(ExpedienteComercial.class, filtroExpedienteComercial);
				
				for(CompradorExpediente compradorExpediente: expedienteComercial.getCompradores()){
					if(compradorExpediente.getPrimaryKey().getComprador().getId().equals(Long.parseLong(dto.getId())) &&
							compradorExpediente.getPrimaryKey().getExpediente().getId().equals(Long.parseLong(dto.getIdExpedienteComercial()))){
					
							if(!Checks.esNulo(dto.getPorcentajeCompra())){
								compradorExpediente.setPorcionCompra(dto.getPorcentajeCompra());
							}
							if(!Checks.esNulo(dto.getTitularContratacion())){
								compradorExpediente.setTitularContratacion(dto.getTitularContratacion());
								if(dto.getTitularContratacion()==1){
									compradorExpediente.setTitularReserva(0);
								}
								else if(dto.getTitularContratacion()==0){
									compradorExpediente.setTitularReserva(1);
								}
							}
							
							//Nexos
							//Falta Reg.economico
							if(!Checks.esNulo(dto.getCodEstadoCivil())){
								DDEstadosCiviles estadoCivil = (DDEstadosCiviles) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosCiviles.class, dto.getCodEstadoCivil());
								compradorExpediente.setEstadoCivil(estadoCivil);
							}
							if(!Checks.esNulo(dto.getDocumentoConyuge())){
								compradorExpediente.setDocumentoConyuge(dto.getDocumentoConyuge());
							}
							if(!Checks.esNulo(dto.getRelacionAntDeudor())){
								compradorExpediente.setRelacionAntDeudor(dto.getRelacionAntDeudor());
							}
							if(!Checks.esNulo(dto.getRelacionHre())){
								compradorExpediente.setRelacionHre(dto.getRelacionHre());
							}
							if(!Checks.esNulo(dto.getCodigoRegimenMatrimonial())){
								DDRegimenesMatrimoniales regimenMatrimonial = (DDRegimenesMatrimoniales) utilDiccionarioApi.dameValorDiccionarioByCod(DDRegimenesMatrimoniales.class, dto.getCodigoRegimenMatrimonial());
								compradorExpediente.setRegimenMatrimonial(regimenMatrimonial);
							}
							
							if(!Checks.esNulo(dto.getAntiguoDeudor())){
								compradorExpediente.setAntiguoDeudor(dto.getAntiguoDeudor());
							}
							
							//Datos representante
							if(!Checks.esNulo(dto.getCodTipoDocumentoRte())){
								DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumentoRte());
								compradorExpediente.setTipoDocumentoRepresentante(tipoDocumento);
							}
							if(!Checks.esNulo(dto.getNombreRazonSocialRte())){
								compradorExpediente.setNombreRepresentante(dto.getNombreRazonSocialRte());
							}
							if(!Checks.esNulo(dto.getApellidosRte())){
								compradorExpediente.setApellidosRepresentante(dto.getApellidosRte());
							}
							
							if(!Checks.esNulo(dto.getProvinciaRteCodigo())){
								DDProvincia provinciaRte = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class, dto.getProvinciaRteCodigo());
								compradorExpediente.setProvinciaRepresentante(provinciaRte);
							}
							
							if(!Checks.esNulo(dto.getMunicipioRteCodigo())){
								Filter filtroLocalidadRte = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioRteCodigo());
								Localidad localidadRte = (Localidad) genericDao.get(Localidad.class, filtroLocalidadRte);
								compradorExpediente.setLocalidadRepresentante(localidadRte);
							}
							if(!Checks.esNulo(dto.getCodigoPostalRte())){
								compradorExpediente.setCodigoPostalRepresentante(dto.getCodigoPostalRte());
							}
							if(!Checks.esNulo(dto.getNumDocumentoRte())){
								compradorExpediente.setDocumentoRepresentante(dto.getNumDocumentoRte());
							}
							if(!Checks.esNulo(dto.getDireccionRte())){
								compradorExpediente.setDireccionRepresentante(dto.getDireccionRte());
							}
							if(!Checks.esNulo(dto.getTelefono1Rte())){
								compradorExpediente.setTelefono1Representante(dto.getTelefono1Rte());
							}
							if(!Checks.esNulo(dto.getTelefono2Rte())){
								compradorExpediente.setTelefono2Representante(dto.getTelefono2Rte());
							}
							if(!Checks.esNulo(dto.getEmailRte())){
								compradorExpediente.setEmailRepresentante(dto.getEmailRte());
							}
						genericDao.save(Comprador.class, comprador);
						genericDao.update(CompradorExpediente.class, compradorExpediente);
						
					}
				
				
				}
				
			}
		}catch (Exception e) {
			e.printStackTrace();
			return false;
		} 
		return true;
	
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean marcarCompradorPrincipal(Long idComprador, Long idExpedienteComercial){
		
		Filter filterLista= genericDao.createFilter(FilterType.EQUALS, "primaryKey.expediente.id", idExpedienteComercial);
		List<CompradorExpediente> listaCompradores= genericDao.getList(CompradorExpediente.class, filterLista);
		
		try{
			for(CompradorExpediente compradorExpediente: listaCompradores){
				if(idComprador.equals(compradorExpediente.getPrimaryKey().getComprador().getId())){
					compradorExpediente.setTitularContratacion(1);
					genericDao.update(CompradorExpediente.class, compradorExpediente);
					
				}
				else{
					compradorExpediente.setTitularContratacion(0);
					genericDao.update(CompradorExpediente.class, compradorExpediente);
					
				}
			}
			return true;
		}catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
	}
	
	@Transactional(readOnly = false)
	public boolean saveHonorario(DtoGastoExpediente dtoGastoExpediente) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoGastoExpediente.getId()));
		GastosExpediente gastoExpediente = genericDao.get(GastosExpediente.class, filtro);
		
		
		try {
			
			if(!Checks.esNulo(dtoGastoExpediente.getParticipacion())){
				DDAccionGastos acciongasto = (DDAccionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDAccionGastos.class, dtoGastoExpediente.getParticipacion());
				if(!Checks.esNulo(acciongasto)){
					gastoExpediente.setAccionGastos(acciongasto);
				}
			}
			
			if(Checks.esNulo(gastoExpediente.getTipoCalculo())){
				DDTipoCalculo tipoCalculo = (DDTipoCalculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoCalculo.class, dtoGastoExpediente.getTipoCalculo());
				gastoExpediente.setTipoCalculo(tipoCalculo);
			}
			
			if(!Checks.esNulo(dtoGastoExpediente.getIdProveedor())){
				Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "id", dtoGastoExpediente.getIdProveedor());
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroProveedor);				
				gastoExpediente.setProveedor(proveedor);
			} 
			gastoExpediente.setImporteCalculo(dtoGastoExpediente.getImporteCalculo());
			gastoExpediente.setImporteFinal(dtoGastoExpediente.getHonorarios());
			gastoExpediente.setObservaciones(dtoGastoExpediente.getObservaciones());
			if(!Checks.esNulo(dtoGastoExpediente.getCodigoTipoProveedor())){
				Filter filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoGastoExpediente.getCodigoTipoProveedor());
				DDTipoProveedorHonorario tipoProveedor = genericDao.get(DDTipoProveedorHonorario.class, filtroTipoProveedor);	
				if(!Checks.esNulo(tipoProveedor)){
					
					if(tipoProveedor.getCodigo().equals(DDTipoProveedorHonorario.CODIGO_CAT) ||tipoProveedor.getCodigo().equals(DDTipoProveedorHonorario.CODIGO_MEDIADOR_OFICINA)){
						gastoExpediente.setProveedor(null);
					}
					gastoExpediente.setTipoProveedor(tipoProveedor);
				}
			}	
			
//			beanUtilNotNull.copyProperties(gastoExpediente, dtoGastoExpediente);			
			genericDao.save(GastosExpediente.class, gastoExpediente);
			
			
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
		return true;
		
	}

	@Transactional(readOnly = true)
	public DDEstadosExpedienteComercial getDDEstadosExpedienteComercialByCodigo (String codigo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
		DDEstadosExpedienteComercial estado = null;
		try {
			estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		} catch(Exception e) {
			return null;
		}		
		return estado;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveFichaExpediente(DtoFichaExpediente dto, Long idExpediente){
		
		ExpedienteComercial expedienteComercial = findOne(idExpediente);

		if(!Checks.esNulo(expedienteComercial)){

			try {
				beanUtilNotNull.copyProperties(expedienteComercial, dto);			

				if(!Checks.esNulo(expedienteComercial.getReserva())){
					if(!Checks.esNulo(dto.getEstadoDevolucionCodigo())) {
						DDEstadoDevolucion estadoDevolucion = (DDEstadoDevolucion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoDevolucion.class, dto.getEstadoDevolucionCodigo());
						expedienteComercial.getReserva().setEstadoDevolucion(estadoDevolucion);
					}
					
					if(!Checks.esNulo(dto.getFechaReserva())) {
						expedienteComercial.getReserva().setFechaEnvio(dto.getFechaReserva());
					}
				}
				if(!Checks.esNulo(expedienteComercial.getUltimoPosicionamiento()) && !Checks.esNulo(dto.getFechaPosicionamiento())){
					expedienteComercial.getUltimoPosicionamiento().setFechaPosicionamiento(dto.getFechaPosicionamiento());
				}

				genericDao.save(ExpedienteComercial.class, expedienteComercial);
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}			
		}

		return true;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveEntregaReserva(DtoEntregaReserva dto, Long idExpediente){
		
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		
		try{		
			if(!Checks.esNulo(expedienteComercial)){
				
				EntregaReserva entrega= new EntregaReserva();
				
	//			entregaReserva.setIdEntrega(entrega.getId());
	//			entregaReserva.setFechaCobro(entrega.getFechaEntrega());
	//			entregaReserva.setImporte(entrega.getImporte());
	//			entregaReserva.setObservaciones(entrega.getObservaciones());
	//			entregaReserva.setTitular(entrega.getTitular());	
				
				entrega.setImporte(dto.getImporte());
				entrega.setFechaEntrega(dto.getFechaCobro());
				entrega.setTitular(dto.getTitular());
				entrega.setObservaciones(dto.getObservaciones());
				entrega.setReserva(expedienteComercial.getReserva());
				
				expedienteComercial.getReserva().getEntregas().add(entrega);
				
				genericDao.save(EntregaReserva.class, entrega);
				
				genericDao.update(ExpedienteComercial.class, expedienteComercial);
				
			}
		}catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
		return true;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean updateEntregaReserva(DtoEntregaReserva dto, Long idExpediente){
		
		ExpedienteComercial expedienteComercial = findOne(idExpediente);
		
		for(EntregaReserva entrega: expedienteComercial.getReserva().getEntregas()){
			
			try {
				
				if(entrega.getId().equals(dto.getIdEntrega())){
					beanUtilNotNull.copyProperties(entrega, dto);
					if(!Checks.esNulo(dto.getFechaCobro())){
						entrega.setFechaEntrega(dto.getFechaCobro());
					}
					if("".equals(dto.getFechaCobro())){
						entrega.setFechaEntrega(null);
					}
					
					genericDao.update(ExpedienteComercial.class, expedienteComercial);
				}
				
			} catch (IllegalAccessException e) {
				e.printStackTrace();
				return false;
			} catch (InvocationTargetException e) {
				e.printStackTrace();
				return false;
			}
			
		}
		
		return true;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean deleteEntregaReserva(DtoEntregaReserva dto, Long idEntrega){

			try {
				genericDao.deleteById(EntregaReserva.class, idEntrega);
				
			} catch (Exception e) {
				e.printStackTrace();
				return false;
			} 
		
		return true;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean createComprador(VBusquedaDatosCompradorExpediente dto, Long idExpediente){
		
		try{
			Comprador comprador= new Comprador();
			CompradorExpediente compradorExpediente= new CompradorExpediente();
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idExpediente);
			ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);
			
			if(!Checks.esNulo(dto.getNumeroClienteUrsus())){
				comprador.setIdCompradorUrsus(dto.getNumeroClienteUrsus());
			}
					
			if(!Checks.esNulo(dto.getCodTipoPersona())){
				DDTiposPersona tipoPersona = (DDTiposPersona) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposPersona.class, dto.getCodTipoPersona());
				comprador.setTipoPersona(tipoPersona);
			}
			//Datos de identificación
			//Faltaria un campo para el apellido
			if(!Checks.esNulo(dto.getApellidos())){
				comprador.setApellidos(dto.getApellidos());
			}
			
			if(!Checks.esNulo(dto.getCodTipoDocumento())){
				DDTipoDocumento tipoDocumentoComprador = (DDTipoDocumento) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumento());
				comprador.setTipoDocumento(tipoDocumentoComprador);
			}
			if(!Checks.esNulo(dto.getNombreRazonSocial())){
			comprador.setNombre(dto.getNombreRazonSocial());
			}
			if(!Checks.esNulo(dto.getProvinciaCodigo())){
				DDProvincia provincia = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class, dto.getProvinciaCodigo());
				comprador.setProvincia(provincia);
			}
			
			if(!Checks.esNulo(dto.getMunicipioCodigo())){
				Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
				Localidad localidad = (Localidad) genericDao.get(Localidad.class, filtroLocalidad);
				comprador.setLocalidad(localidad);
			}
			if(!Checks.esNulo(dto.getCodigoPostal())){
				comprador.setCodigoPostal(dto.getCodigoPostal());
			}
			if(!Checks.esNulo(dto.getNumDocumento())){
				comprador.setDocumento(dto.getNumDocumento());
			}
			if(!Checks.esNulo(dto.getDireccion())){
				comprador.setDireccion(dto.getDireccion());
			}
			if(!Checks.esNulo(dto.getTelefono1())){
				comprador.setTelefono1(dto.getTelefono1());
			}
			if(!Checks.esNulo(dto.getTelefono2())){
				comprador.setTelefono2(dto.getTelefono2());
			}
			if(!Checks.esNulo(dto.getEmail())){
				comprador.setEmail(dto.getEmail());
			}
			
			if(!Checks.esNulo(dto.getTitularReserva())){
				compradorExpediente.setTitularReserva(dto.getTitularReserva());
			}
			
			compradorExpediente.setPorcionCompra(dto.getPorcentajeCompra());
			
			if(!Checks.esNulo(dto.getTitularContratacion())){
				compradorExpediente.setTitularContratacion(dto.getTitularContratacion());;
			
			}else{
				compradorExpediente.setTitularContratacion(0);
			}
			
			//Nexos
			//Falta Reg.economico
			if(!Checks.esNulo(dto.getCodEstadoCivil())){
				DDEstadosCiviles estadoCivil = (DDEstadosCiviles) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosCiviles.class, dto.getCodEstadoCivil());
				compradorExpediente.setEstadoCivil(estadoCivil);
			}
			if(!Checks.esNulo(dto.getDocumentoConyuge())){
				compradorExpediente.setDocumentoConyuge(dto.getDocumentoConyuge());
			}
			if(!Checks.esNulo(dto.getRelacionAntDeudor())){
				compradorExpediente.setRelacionAntDeudor(dto.getRelacionAntDeudor());
			}
			if(!Checks.esNulo(dto.getRelacionHre())){
				compradorExpediente.setRelacionHre(dto.getRelacionHre());
			}
			if(!Checks.esNulo(dto.getCodigoRegimenMatrimonial())){
				DDRegimenesMatrimoniales regimenMatrimonial = (DDRegimenesMatrimoniales) utilDiccionarioApi.dameValorDiccionarioByCod(DDRegimenesMatrimoniales.class, dto.getCodigoRegimenMatrimonial());
				compradorExpediente.setRegimenMatrimonial(regimenMatrimonial);
			}
			
			if(!Checks.esNulo(dto.getAntiguoDeudor())){
				compradorExpediente.setAntiguoDeudor(dto.getAntiguoDeudor());
			}
			
			//Datos representante
			if(!Checks.esNulo(dto.getCodTipoDocumentoRte())){
				DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getCodTipoDocumentoRte());
				compradorExpediente.setTipoDocumentoRepresentante(tipoDocumento);
			}
			if(!Checks.esNulo(dto.getNombreRazonSocialRte())){
				compradorExpediente.setNombreRepresentante(dto.getNombreRazonSocialRte());
			}
			if(!Checks.esNulo(dto.getApellidosRte())){
				compradorExpediente.setApellidosRepresentante(dto.getApellidosRte());
			}
			if(!Checks.esNulo(dto.getProvinciaRteCodigo())){
				DDProvincia provinciaRte = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class, dto.getProvinciaRteCodigo());
				compradorExpediente.setProvinciaRepresentante(provinciaRte);
			}
			
			if(!Checks.esNulo(dto.getMunicipioRteCodigo())){
				Filter filtroLocalidadRte = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioRteCodigo());
				Localidad localidadRte = (Localidad) genericDao.get(Localidad.class, filtroLocalidadRte);
				compradorExpediente.setLocalidadRepresentante(localidadRte);
			}
			if(!Checks.esNulo(dto.getCodigoPostalRte())){
				compradorExpediente.setCodigoPostalRepresentante(dto.getCodigoPostalRte());
			}
			if(!Checks.esNulo(dto.getNumDocumentoRte())){
				compradorExpediente.setDocumentoRepresentante(dto.getNumDocumentoRte());
			}
			if(!Checks.esNulo(dto.getDireccionRte())){
				compradorExpediente.setDireccionRepresentante(dto.getDireccionRte());
			}
			if(!Checks.esNulo(dto.getTelefono1Rte())){
				compradorExpediente.setTelefono1Representante(dto.getTelefono1Rte());
			}
			if(!Checks.esNulo(dto.getTelefono2Rte())){
				compradorExpediente.setTelefono2Representante(dto.getTelefono2Rte());
			}
			if(!Checks.esNulo(dto.getEmailRte())){
				compradorExpediente.setEmailRepresentante(dto.getEmailRte());
			}
			
			CompradorExpedientePk pk= new CompradorExpedientePk();
			pk.setComprador(comprador);
			pk.setExpediente(expediente);
			compradorExpediente.setPrimaryKey(pk);
			
			genericDao.save(Comprador.class, comprador);			
			expediente.getCompradores().add(compradorExpediente);
			
			genericDao.save(ExpedienteComercial.class, expediente);
			
			
			return true;
			
		}catch (Exception e) {
			e.printStackTrace();
			return false;
		} 
				
	}
	
	@Override
	public String consultarComiteSancionador(Long idExpediente) throws Exception {
		
		ExpedienteComercial expediente = findOne(idExpediente);
		//InstanciaDecisionDto instancia = expedienteComercialToInstanciaDecision(expediente);
		InstanciaDecisionDto instancia = expedienteComercialToInstanciaDecision(expediente);
		String codigoComite = null;
			
		ResultadoInstanciaDecisionDto resultadoDto;
		try {
			resultadoDto = uvemManagerApi.consultarInstanciaDecision(instancia);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw new Exception(e);
		}
		
		codigoComite = resultadoDto.getCodigoComite();
			
		
		return codigoComite;	
		
	}

	private InstanciaDecisionDto expedienteComercialToInstanciaDecision(ExpedienteComercial expediente) {
		
		InstanciaDecisionDto instancia = new InstanciaDecisionDto();
		Oferta oferta = expediente.getOferta();
		Activo activo = oferta.getActivoPrincipal();
		
		boolean solicitaFinanciacion = false;
		int numActivoEspecial = 0;
		Long importe = new Long(0);
		short tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_SIN_IMPUESTO;
		
		if(!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getSolicitaFinanciacion())) {			
			solicitaFinanciacion = BooleanUtils.toBoolean(solicitaFinanciacion);
		}

		numActivoEspecial = Checks.esNulo(activo.getNumActivoUvem()) ? 0 : activo.getNumActivoUvem().intValue();
		importe = Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteOferta().longValue() : oferta.getImporteContraOferta().longValue();
		
		if(!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getTipoImpuesto())) {
			String tipoImpuestoCodigo = expediente.getCondicionante().getTipoImpuesto().getCodigo(); 
			if (DDTiposImpuesto.TIPO_IMPUESTO_IVA.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IVA;
			if (DDTiposImpuesto.TIPO_IMPUESTO_IGIC.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IGIC;
			if (DDTiposImpuesto.TIPO_IMPUESTO_IPSI.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IPSI;
			if (DDTiposImpuesto.TIPO_IMPUESTO_ITP.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_ITP;
		}	
		
		InstanciaDecisionDataDto instData = new InstanciaDecisionDataDto();
		instData.setIdentificadorActivoEspecial(numActivoEspecial);
		instData.setImporteConSigno(importe);
		instData.setTipoDeImpuesto(tipoDeImpuesto);
		
		List<InstanciaDecisionDataDto> instanciaList  = new ArrayList<InstanciaDecisionDataDto>();
		instanciaList.add(instData);
		
		instancia.setCodigoDeOfertaHaya("0");
		instancia.setFinanciacionCliente(solicitaFinanciacion);
		instancia.setData(instanciaList);
		
		return instancia;
	}
	
	
	public InstanciaDecisionDto expedienteComercialToInstanciaDecisionList(ExpedienteComercial expediente, Long porcentajeImpuesto ) throws Exception {
		
		InstanciaDecisionDto instancia = new InstanciaDecisionDto();
		Double importeXActivo = null;
		short tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_SIN_IMPUESTO;
		List<InstanciaDecisionDataDto> instanciaList  = new ArrayList<InstanciaDecisionDataDto>();
		boolean solicitaFinanciacion = false;
		
		Oferta oferta = expediente.getOferta();
		if(Checks.esNulo(oferta)){
			throw new Exception("No existe oferta para el expediente.");
		}
					
		List<ActivoOferta> listaActivos = oferta.getActivosOferta();
		if(Checks.esNulo(listaActivos) || (!Checks.esNulo(listaActivos) && listaActivos.size()==0)){
			throw new Exception("No hay activos para la oferta indicada.");
		}
		
		
		for(int i=0; i< listaActivos.size(); i++){
			Activo activo = listaActivos.get(i).getPrimaryKey().getActivo();
			if(Checks.esNulo(activo)){
				throw new Exception("No se ha podido obtener el activo.");
			}
			
			if(Checks.esNulo(activo.getNumActivoUvem())){
				throw new Exception("El activo no tiene número de UVEM.");
			}
			
			Double porcentajeParti = listaActivos.get(i).getPorcentajeParticipacion();
			Double importeTotal = Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteOferta() : oferta.getImporteContraOferta();
			
			try {
				importeXActivo = (importeTotal * porcentajeParti)/100;
			} catch (Exception e) {
				logger.error(e);
			}
			InstanciaDecisionDataDto instData = new InstanciaDecisionDataDto();
			//ImportePorActivo
			instData.setImporteConSigno(importeXActivo.longValue());
			//NumActivoUvem
			instData.setIdentificadorActivoEspecial(Integer.valueOf(activo.getNumActivoUvem().toString()));
			
			//TipoImpuesto
			if(!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getTipoImpuesto())) {
				String tipoImpuestoCodigo = expediente.getCondicionante().getTipoImpuesto().getCodigo(); 
				if (DDTiposImpuesto.TIPO_IMPUESTO_IVA.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IVA;
				if (DDTiposImpuesto.TIPO_IMPUESTO_IGIC.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IGIC;
				if (DDTiposImpuesto.TIPO_IMPUESTO_IPSI.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_IPSI;
				if (DDTiposImpuesto.TIPO_IMPUESTO_ITP.equals(tipoImpuestoCodigo)) tipoDeImpuesto = InstanciaDecisionDataDto.TIPO_IMPUESTO_ITP;
			}	
			instData.setTipoDeImpuesto(tipoDeImpuesto);	
			//PorcentajeImpuesto
			instData.setPorcentajeImpuesto(porcentajeImpuesto.intValue());
			instanciaList.add(instData);
		}
		
		
		//SolicitaFinaciacion
		if(!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getSolicitaFinanciacion())) {			
			solicitaFinanciacion = BooleanUtils.toBoolean(solicitaFinanciacion);
		}
		instancia.setFinanciacionCliente(solicitaFinanciacion);
		//OfertaHRE
		instancia.setCodigoDeOfertaHaya(oferta.getNumOferta().toString());
		instancia.setData(instanciaList);

		return instancia;
	}

	

	@Override
	@Transactional(readOnly = false)
	public boolean createPosicionamiento(DtoPosicionamiento dto, Long idEntidad) {
		
		ExpedienteComercial expediente = findOne(idEntidad);	
		Posicionamiento posicionamiento = new Posicionamiento();
		
		posicionamiento = dtoToPosicionamiento(dto, posicionamiento);
		posicionamiento.setExpediente(expediente);
		
		genericDao.save(Posicionamiento.class, posicionamiento);
		
		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean savePosicionamiento(DtoPosicionamiento dto) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdPosicionamiento());
		Posicionamiento posicionamiento = genericDao.get(Posicionamiento.class, filtro);
		
		posicionamiento = dtoToPosicionamiento(dto, posicionamiento);			
		genericDao.update(Posicionamiento.class, posicionamiento);
			
		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deletePosicionamiento(Long idPosicionamiento) {
		
		try {
			genericDao.deleteById(Posicionamiento.class, idPosicionamiento);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		return true;
		
	}
	
	@Override
	public List<DtoActivoProveedor> getNotariosExpediente(Long idExpediente){
		ExpedienteComercial expediente= findOne(idExpediente);
		List<DtoActivoProveedor> notarios= new ArrayList<DtoActivoProveedor>();
		for(Posicionamiento posicionamiento : expediente.getPosicionamientos()) {
			
			ActivoProveedor notario = posicionamiento.getNotario();
			DtoActivoProveedor dtoNotario = activoProveedorToDto(notario);		
			notarios.add(dtoNotario);

		}
		
		return notarios;
		
	}

	private DtoActivoProveedor activoProveedorToDto(ActivoProveedor notario) {
		
		DtoActivoProveedor proveedorDto= new DtoActivoProveedor();
		String nombreCompleto= "";
		
		proveedorDto.setId(notario.getId());
		if(!Checks.esNulo(notario.getNombre())){
			nombreCompleto= notario.getNombre();
		} else {
			nombreCompleto = notario.getNombreComercial();
		}
		
		proveedorDto.setNombreProveedor(nombreCompleto);
		proveedorDto.setDireccion(notario.getDireccion());


		if(!Checks.esNulo(notario.getTelefono1())){
			proveedorDto.setTelefono(notario.getTelefono1());
		}
		else{
			proveedorDto.setTelefono(notario.getTelefono2());
		}
		proveedorDto.setEmail(notario.getEmail());
		if(!Checks.esNulo(notario.getProvincia())){
			proveedorDto.setProvincia(notario.getProvincia().getDescripcion());
		}
		
		return proveedorDto;
	}
	
	public DatosClienteDto buscarNumeroUrsus(String numeroDocumento, String tipoDocumento) throws Exception{
		
		DtoClienteUrsus compradorUrsus= new DtoClienteUrsus();
		DatosClienteDto dtoDatosCliente= new DatosClienteDto();
		String tipoDoc = null;
		
		if(!Checks.esNulo(tipoDocumento)){
			if (DDTiposDocumentos.DNI.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.DNI;	
			if (DDTiposDocumentos.CIF.equals(tipoDocumento))  tipoDoc = DtoClienteUrsus.CIF;
			if (DDTiposDocumentos.DNI.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.DNI;
			if (DDTiposDocumentos.TARJETA_RESIDENTE.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.TARJETA_RESIDENTE;
			if (DDTiposDocumentos.PASAPORTE.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.PASAPORTE;
			if (DDTiposDocumentos.CIF_EXTRANJERO.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.CIF_EXTRANJERO;
			if (DDTiposDocumentos.DNI_EXTRANJERO.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.DNI_EXTRANJERO;
			if (DDTiposDocumentos.TARJETA_DIPLOMATICA.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.TARJETA_DIPLOMATICA;
			if (DDTiposDocumentos.MENOR.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.MENOR;
			if (DDTiposDocumentos.OTROS_PERSONA_FISICA.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.OTROS_PERSONA_FISICA;
			if (DDTiposDocumentos.OTROS_PESONA_JURIDICA.equals(tipoDocumento)) tipoDoc = DtoClienteUrsus.OTROS_PESONA_JURIDICA;
		}
		
		if(!Checks.esNulo(numeroDocumento)){
			compradorUrsus.setNumDocumento(numeroDocumento.toString());
		}
		compradorUrsus.setTipoDocumento(tipoDoc);
		compradorUrsus.setQcenre(DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA);
		
		
		try {
			//dtoDatosCliente.rellenarDatosDummies();
			dtoDatosCliente= uvemManagerApi.ejecutarDatosClientePorDocumento(compradorUrsus);
			if(Checks.esNulo(dtoDatosCliente.getDniNifDelTitularDeLaOferta())){
				throw new JsonViewerException("Cliente Ursus no encontrado");
			}
		}
		catch (JsonViewerException e) {
			logger.error(e.getMessage());
			throw e;
//			e.printStackTrace();
		} 
		catch (Exception e) {
			logger.error(e.getMessage());
			throw new Exception(e);
//			e.printStackTrace();
		}
		
		return dtoDatosCliente;
		
	}
	
	@SuppressWarnings("unchecked")
	public List<ActivoProveedor> getComboProveedoresExpediente(String codigoTipoProveedor, String nombreBusqueda, WebDto dto){
		
		List<ActivoProveedor> proveedores= new ArrayList<ActivoProveedor>();
		
		Filter filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoProveedor);
		DDTipoProveedor tipoProveedor = genericDao.get(DDTipoProveedor.class, filtroTipoProveedor);
		
		
		if(!Checks.esNulo(nombreBusqueda) && !Checks.esNulo(tipoProveedor)){
			
			Page page = expedienteComercialDao.getComboProveedoresExpediente(codigoTipoProveedor, nombreBusqueda, dto);	
			proveedores= (List<ActivoProveedor>) page.getResults();
			
		}
		else if(!Checks.esNulo(tipoProveedor)){
			
			Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.id", tipoProveedor.getId());
			proveedores = genericDao.getList(ActivoProveedor.class, filtroProveedor);
		}
		
		return proveedores;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean createHonorario(DtoGastoExpediente dto, Long idEntidad){
		
		ExpedienteComercial expediente = findOne(idEntidad);	
		GastosExpediente gastoExpediente= new GastosExpediente();
		
		try{
			if(!Checks.esNulo(dto.getParticipacion())){
				Filter filtroAccionGasto = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getParticipacion());
				DDAccionGastos accionGastos = genericDao.get(DDAccionGastos.class, filtroAccionGasto);
				gastoExpediente.setAccionGastos(accionGastos);
			}
			
			if(!Checks.esNulo(dto.getCodigoTipoProveedor())){
				Filter filtroTipoProveedor = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoTipoProveedor());
				DDTipoProveedorHonorario tipoProveedor = genericDao.get(DDTipoProveedorHonorario.class, filtroTipoProveedor);
				gastoExpediente.setTipoProveedor(tipoProveedor);
			}
			
			if(!Checks.esNulo(dto.getIdProveedor())){
				Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdProveedor());
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroProveedor);				
				gastoExpediente.setProveedor(proveedor);
			}
			
			if(!Checks.esNulo(dto.getTipoCalculo())){
				Filter filtroTipoCalculo = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getTipoCalculo()));
				DDTipoCalculo tipoCalculo = genericDao.get(DDTipoCalculo.class, filtroTipoCalculo);				
				gastoExpediente.setTipoCalculo(tipoCalculo);
			}
			
			gastoExpediente.setImporteCalculo(dto.getImporteCalculo());
			gastoExpediente.setImporteFinal(dto.getHonorarios());
			gastoExpediente.setObservaciones(dto.getObservaciones());		
			gastoExpediente.setExpediente(expediente);
			
			genericDao.save(GastosExpediente.class, gastoExpediente);
			
			return true;
			
		}catch (Exception e) {
			e.printStackTrace();
			return false;
		} 
	}
	
	@Transactional(readOnly = false)
	public boolean deleteHonorario(Long idHonorario) {
		
		try {
			
			genericDao.deleteById(GastosExpediente.class, idHonorario);
			
		} catch (Exception e) {
			e.printStackTrace();
		} 

		return true;
		
	}


	@Override
	public OfertaUVEMDto createOfertaOVEM(Oferta oferta,ExpedienteComercial expedienteComercial) {
		Double importeReserva = null;
		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		OfertaUVEMDto ofertaUVEM = new OfertaUVEMDto();
		if (oferta.getTipoOferta() != null) {
			ofertaUVEM.setCodOpcion(oferta.getTipoOferta().getCodigo());
		}
		if (oferta.getNumOferta() != null) {
			ofertaUVEM.setCodOfertaHRE(oferta.getNumOferta().toString());
		}
		if (oferta.getPrescriptor() != null) {
			ofertaUVEM.setCodPrescriptor(oferta.getPrescriptor().getCodProveedorUvem());
		}
		if (condExp != null) {
			if (DDTipoCalculo.TIPO_CALCULO_PORCENTAJE.equals(condExp.getTipoCalculoReserva())) {
				importeReserva = condExp.getPorcentajeReserva() * oferta.getImporteOferta();
				if (importeReserva != null) {
					ofertaUVEM.setImporteReserva(importeReserva.toString());
				}
			} else {
				importeReserva = condExp.getImporteReserva();
				if (importeReserva != null) {
					ofertaUVEM.setImporteReserva(importeReserva.toString());
				}
			}
		}
		if (oferta.getImporteOferta() != null) {
			ofertaUVEM.setImporteVenta(oferta.getImporteOferta().toString());
		}
		return ofertaUVEM;
	}

	@Override
	public ArrayList<TitularUVEMDto> obtenerListaTitularesUVEM(ExpedienteComercial expedienteComercial) {
		ArrayList<TitularUVEMDto> listaTitularUVEM = new ArrayList<TitularUVEMDto>();
		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		for (int k = 0; k < expedienteComercial.getCompradores().size(); k++) {
			CompradorExpediente compradorExpediente = expedienteComercial.getCompradores().get(k);
			TitularUVEMDto titularUVEM = new TitularUVEMDto();
			if (compradorExpediente.getComprador() != null) {
				titularUVEM.setCliente(compradorExpediente.getComprador().toString());
			}
			if (compradorExpediente.getImporteProporcionalOferta() != null) {
				titularUVEM.setPorcentaje(compradorExpediente.getPorcionCompra().toString());
			}
			if (condExp.getReservaConImpuesto() != null && condExp.getReservaConImpuesto() == 1) {
				titularUVEM.setImpuestos("S");
			} else {
				titularUVEM.setImpuestos("N");
			}
			if (condExp.getEntidadFinanciacion() != null) {
				titularUVEM.setEntidad(condExp.getEntidadFinanciacion());
			}
			if (expedienteComercial.getReserva() != null) {
				if (expedienteComercial.getReserva().getTipoArras() != null) {
					if (DDTiposArras.CONFIRMATORIAS.equals(expedienteComercial.getReserva().getTipoArras().getCodigo())) {
						titularUVEM.setArras("A");
					} else {
						titularUVEM.setArras("B");
					}
				} else {
					titularUVEM.setArras("");
				}
			}
			listaTitularUVEM.add(titularUVEM);
		}
		return listaTitularUVEM;
	}
	
	@Transactional(readOnly = false)
	public boolean deleteCompradorExpediente(Long idExpediente, Long idComprador) {
		
		try {
			
			Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "primaryKey.expediente.id", idExpediente);
			Filter filtroComprador = genericDao.createFilter(FilterType.EQUALS, "primaryKey.comprador.id", idComprador);
			
			CompradorExpediente compradorExpediente = genericDao.get(CompradorExpediente.class, filtroExpediente, filtroComprador);
			

			if(!Checks.esNulo(compradorExpediente)){
				if(compradorExpediente.getTitularContratacion()==0){
					expedienteComercialDao.deleteCompradorExpediente(idExpediente, idComprador);
				}
				else{
					throw new JsonViewerException("Operación no permitida, por ser el titular de la contratación");
				}
			}else{
				throw new JsonViewerException("Error al eliminar comprador");
			}
			
				
			
		} 
		catch (JsonViewerException e) {
			logger.error(e.getMessage());
			throw e;
//			e.printStackTrace();
		} 
		catch (Exception e) {
			e.printStackTrace();
		} 

		return true;
		
	}
	
	@Transactional(readOnly = false)
	public boolean updateListadoActivos(DtoActivosExpediente dto, Long id){
		
		ExpedienteComercial expedienteComercial = findOne(id);
		Oferta oferta= expedienteComercial.getOferta();
		try{
		//Recorre la relacion activo-trabajo del expediente, modifica la participacion del que coincida con el activo que estamos buscando
//				if(!Checks.esNulo(expedienteComercial.getTrabajo())){
//					for(ActivoTrabajo activoTrabajo: expedienteComercial.getTrabajo().getActivosTrabajo()){
//						
//						if(!Checks.esNulo(dto.getIdActivo()) && !Checks.esNulo(dto.getPorcentajeParticipacion()) && activoTrabajo.getPrimaryKey().getActivo().getId().equals(dto.getIdActivo())){
//							activoTrabajo.setParticipacion(Float.parseFloat(dto.getPorcentajeParticipacion().toString()));
//							genericDao.update(ActivoTrabajo.class, activoTrabajo);
//							return true;
//						}
//					}
//				}
			List<ActivoOferta> activosOferta= expedienteComercial.getOferta().getActivosOferta();
			for(ActivoOferta activoOferta: activosOferta){
				if(activoOferta.getPrimaryKey().getActivo().getId().equals(dto.getIdActivo())){
					if(!Checks.esNulo(dto.getIdActivo())){
						if(!Checks.esNulo(dto.getPorcentajeParticipacion())){
							activoOferta.setPorcentajeParticipacion(dto.getPorcentajeParticipacion());
							activoOferta.setImporteActivoOferta((oferta.getImporteOferta()*dto.getPorcentajeParticipacion())/100);
						}
					}
				}
			}
			
		}catch(Exception e) {
			return false;
		}
		
		return true;
		
	}

}
