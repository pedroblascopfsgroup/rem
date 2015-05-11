package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.manager;

import java.io.File;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.HtmlUtils;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.oficina.dao.OficinaDao;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dao.SubastaDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarLotesSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchAcuerdoCierreDeuda;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoLoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDTipoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteBien;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContext;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBValoracionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.dao.NMBBienDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.DatosActaComiteBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.InformeSubastaLetradoBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.ProcedimientoApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.SubastaApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.BienSubastaDTO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.GuardarInstruccionesDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.LoteSubastaMasivaDTO;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


@Service("subastaManager")
@Transactional(readOnly = false)
public class SubastaManager implements SubastaApi {
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private SubastaDao subastaDao;	

	@Autowired
	private OficinaDao oficinaDao;	
	
	@Autowired
	private NMBBienDao nmbBienDao;
	
	@Autowired
	private Executor executor;

	@Resource
	private Properties appProperties;
	
	@Autowired
	UtilDiccionarioApi diccionarioApi;

	@Autowired
	NMBProjectContext projectContext;
	
	
	@Override
	public List<Subasta> getSubastasAsunto(Long idAsunto) {
		return genericDao.getList(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	@Override
	public List<LoteSubasta> getLotesSubasta(Long idSubasta) {
		Subasta subasta = subastaDao.get(idSubasta);
		if (!Checks.esNulo(subasta)) {
			return subasta.getLotesSubasta();
		}
		return null;
	}

	@Override
	public List<BienSubastaDTO> getBienesAgregarExcluir(Long idSubasta, String accion) {
		List<BienSubastaDTO> bienesReturn = new ArrayList<BienSubastaDTO>();
		
		
		Subasta subasta = subastaDao.get(idSubasta);		
		
		if (!Checks.esNulo(subasta)) {
			
			List<LoteSubasta> lotesSubasta = subasta.getLotesSubasta();
			
			Long idProcedimiento = subasta.getProcedimiento().getId();
			if (SubastaApi.ACCION_AGREGAR_BIEN.equals(accion)) {
				List<Bien> bienesSubasta = new ArrayList<Bien>();
				
				for (LoteSubasta loteSubasta : lotesSubasta) {
					bienesSubasta.addAll(loteSubasta.getBienes());
				}
				
				List<Bien> bienesProcedimiento = proxyFactory.proxy(ProcedimientoApi.class).getBienesDeUnProcedimiento(idProcedimiento);
				for (Bien bien : bienesProcedimiento) {
					if (!bienesSubasta.contains(bien)) {						
						bienesReturn.add(mapeaDtoBienes(bien,null));
					}
				}
			} else {
				for (LoteSubasta lb : lotesSubasta) {				
					for (Bien bien : lb.getBienes()) {
						bienesReturn.add(mapeaDtoBienes(bien,lb.getNumLote()));
					}
				}
			}
			
		}
		return bienesReturn;
	}
	

	private BienSubastaDTO mapeaDtoBienes(Object bien,Integer idLote) {
		BienSubastaDTO bienDto = new BienSubastaDTO();
		
		if (bien instanceof NMBBien) {
			NMBBien nmbBien = (NMBBien) bien;
			bienDto.setId(nmbBien.getId());
			bienDto.setCodigo(nmbBien.getCodigoInterno());
			bienDto.setOrigen(nmbBien.getOrigen().getDescripcion());
			bienDto.setDescripcion(nmbBien.getDescripcionBien());
			bienDto.setTipo(nmbBien.getTipoBien().getDescripcion());
			bienDto.setLote(idLote);
			bienDto.setReferenciaCatastral(nmbBien.getReferenciaCatastral());
			if(!Checks.esNulo(nmbBien.getNumeroActivo())) {
				bienDto.setNumActivo(Long.valueOf(nmbBien.getNumeroActivo()));
			}
			if(!Checks.esNulo(nmbBien.getDatosRegistralesActivo())) {
				bienDto.setNumFinca(nmbBien.getDatosRegistralesActivo().getNumFinca());
			}
		}
		
		return bienDto;
	}

	@Override
	public void agregarBienes(Long idSubasta, String[] arrBien,
			String[] arrLotes) {
		
		Subasta subasta = subastaDao.get(idSubasta);		
		if (!Checks.esNulo(subasta)) {			
			List<LoteSubasta> lotesSubasta = subasta.getLotesSubasta();
			for (int i=0; i<arrBien.length;i++) {
				NMBBien bien = nmbBienDao.get(Long.parseLong(arrBien[i]));
				
				LoteSubasta loteSubasta = null;
				List<Bien> bienes = new ArrayList<Bien>();
				
				boolean esNuevo = true;
				Integer posLote = Integer.parseInt(arrLotes[i]);
				for(LoteSubasta lbs : lotesSubasta){
					if(posLote.equals(lbs.getNumLote())){
						loteSubasta = lbs;
						bienes = lbs.getBienes();
						esNuevo = false;
					}
				}
				if (esNuevo) {
					DDEstadoLoteSubasta estadoInicial = (DDEstadoLoteSubasta)diccionarioApi.dameValorDiccionarioByCod(DDEstadoLoteSubasta.class, DDEstadoLoteSubasta.CONFORMADA);
					loteSubasta = new LoteSubasta();
					loteSubasta.setEstado(estadoInicial);
					loteSubasta.setFechaEstado(new Date());
					loteSubasta.setSubasta(subasta);
					loteSubasta.setNumLote(posLote);
					lotesSubasta.add(loteSubasta);
				} 
				
				bienes.add(bien);
				loteSubasta.setBienes(bienes);
				
				if (esNuevo) {
					genericDao.save(LoteSubasta.class, loteSubasta);
				} else {
					genericDao.update(LoteSubasta.class, loteSubasta);
				}
				
			}
			
		}
	}

	@Override
	public void excluirBienes(Long idSubasta, String[] arrBien) {
		Subasta subasta = subastaDao.get(idSubasta);		
		if (!Checks.esNulo(subasta)) {	
			List<LoteSubasta> lotesSubasta = subasta.getLotesSubasta();
			for (int i=0; i<arrBien.length;i++) {
				NMBBien bien = nmbBienDao.get(Long.parseLong(arrBien[i]));
				
				for(LoteSubasta loteSubasta : lotesSubasta) {
					if (loteSubasta.getBienes().remove(bien)) {
					
						if (Checks.estaVacio(loteSubasta.getBienes())) {
							genericDao.deleteById(LoteSubasta.class, loteSubasta.getId());
						} else {
							genericDao.update(LoteSubasta.class, loteSubasta);
						}
					
						break;
					}
				}
				
			}
			
		}
		
	}

	@Override
	public LoteSubasta getLoteSubasta(Long idLote) {
		return genericDao.get(LoteSubasta.class, genericDao.createFilter(FilterType.EQUALS, "id", idLote), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	@Override
	public void guardaInstruccionesLoteSubasta(GuardarInstruccionesDto dto) {
		LoteSubasta loteSubasta = this.getLoteSubasta(Long.parseLong(dto.getIdLote()));
		if (!Checks.esNulo(loteSubasta)) {
			loteSubasta.setInsPujaSinPostores(Checks.esNulo(dto.getPujaSinPostores()) ? null : Float.parseFloat(dto.getPujaSinPostores()));
			loteSubasta.setInsPujaPostoresDesde(Checks.esNulo(dto.getPujaPostoresDesde()) ? null : Float.parseFloat(dto.getPujaPostoresDesde()));
			loteSubasta.setInsPujaPostoresHasta(Checks.esNulo(dto.getPujaPostoresHasta()) ? null : Float.parseFloat(dto.getPujaPostoresHasta()));
			loteSubasta.setInsValorSubasta(Checks.esNulo(dto.getValorSubasta()) ? null : Float.parseFloat(dto.getValorSubasta()));
			loteSubasta.setIns50DelTipoSubasta(Checks.esNulo(dto.getTipoSubasta50()) ? null : Float.parseFloat(dto.getTipoSubasta50()));
			loteSubasta.setIns60DelTipoSubasta(Checks.esNulo(dto.getTipoSubasta60()) ? null : Float.parseFloat(dto.getTipoSubasta60()));
			loteSubasta.setIns70DelTipoSubasta(Checks.esNulo(dto.getTipoSubasta70()) ? null : Float.parseFloat(dto.getTipoSubasta70()));
			loteSubasta.setObservaciones(Checks.esNulo(dto.getObservaciones()) ? null : HtmlUtils.htmlUnescape(dto.getObservaciones()));
			if (!Checks.esNulo(dto.getRiesgoConsignacion())) {
				DDSiNo sino = (DDSiNo)diccionarioApi.dameValorDiccionarioByCod(DDSiNo.class, dto.getRiesgoConsignacion());	
				loteSubasta.setRiesgoConsignacion(sino!=null && DDSiNo.SI.equals(sino.getCodigo()));
			}
			loteSubasta.setDeudaJudicial(Checks.esNulo(dto.getDeudaJudicial()) ? null : Float.parseFloat(dto.getDeudaJudicial()));
			genericDao.update(LoteSubasta.class, loteSubasta);
		}
	}

	private boolean checkInsSubasta(LoteSubasta loteSubasta) {
		if ((Checks.esNulo(loteSubasta.getInsPujaSinPostores())) || (Checks.esNulo(loteSubasta.getInsPujaPostoresDesde())) || (Checks.esNulo(loteSubasta.getInsPujaPostoresHasta())) || 
				(Checks.esNulo(loteSubasta.getIns50DelTipoSubasta())) || (Checks.esNulo(loteSubasta.getIns60DelTipoSubasta())) || (Checks.esNulo(loteSubasta.getIns70DelTipoSubasta())) 
				|| (Checks.esNulo(loteSubasta.getInsValorSubasta()))) {
			return false;
		}
		return true;
	}

	private Boolean checkTasacion(NMBBien nmbBien) {
		if (Checks.estaVacio(nmbBien.getValoraciones())) {
			return false;
		}
		for (NMBValoracionesBien nmbValoracionesBien : nmbBien.getValoraciones()) {
			if (Checks.esNulo(nmbValoracionesBien.getFechaValorTasacion())) {
				return false;
			} else {
				Date d = new Date();
				Long diferencia = restaFechas(d, nmbValoracionesBien.getFechaValorTasacion());
				if (diferencia.intValue() > 90) {
					return false;
				}
			}
		}
		return true;
	}
	
	private Boolean checkInfLetrado(NMBBien nmbBien) {
		if (Checks.esNulo(nmbBien.getViviendaHabitual())  || Checks.esNulo(nmbBien.getSituacionPosesoria())
				|| Checks.esNulo(nmbBien.getAdicional()) || Checks.esNulo(nmbBien.getAdicional().getFechaRevision()) ) {
			return false;
		}
		return true;
	}
	
	@Override
	@BusinessOperation(BO_NMB_SUBASTA_GET_FECHA_TASACION)
	public Boolean getCheckFechaTasacionSubasta(Long idSubasta) {
		Subasta subasta = subastaDao.get(idSubasta);
		
		if (Checks.esNulo(subasta) || Checks.estaVacio(subasta.getLotesSubasta())) return false;
		for (LoteSubasta loteSubasta : subasta.getLotesSubasta()) {

			if (Checks.estaVacio(loteSubasta.getBienes())) return false;
			for (Bien bien : loteSubasta.getBienes()) {
		
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
				
					if (!checkTasacion(nmbBien)) {
						return false;
					}
				}				
			}
		}
		return true;
	}

	@Override
	@BusinessOperation(BO_NMB_SUBASTA_GET_CHECK_INF_LETRADO)
	public Boolean getCheckInfLetrado(Long idSubasta) {
		Subasta subasta = subastaDao.get(idSubasta);
		
		if (Checks.esNulo(subasta) || Checks.estaVacio(subasta.getLotesSubasta())) return false;
		for (LoteSubasta loteSubasta : subasta.getLotesSubasta()) {

			if (Checks.estaVacio(loteSubasta.getBienes())) return false;
			for (Bien bien : loteSubasta.getBienes()) {
		
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					if (!checkInfLetrado(nmbBien)) {
						return false;
					}
				}
			}
		}	
		return true;
	}

	@Override
	@BusinessOperation(BO_NMB_SUBASTA_GET_CHECK_INS_SUBASTA)
	public Boolean getCheckInsSubasta(Long idSubasta) {
		Subasta subasta = subastaDao.get(idSubasta);
		
		if (Checks.esNulo(subasta) || Checks.estaVacio(subasta.getLotesSubasta())) return false;		
		
		for (LoteSubasta loteSubasta : subasta.getLotesSubasta()) {
			
			if (!checkInsSubasta(loteSubasta)) {
				return false;
			}
		}
		
		return true;
	}

	@Override
	@BusinessOperation(BO_NMB_SUBASTA_GET_CHECK_VALIDA_INS)
	public Boolean getCheckValidaIns(Long idSubasta) {
		Subasta subasta = subastaDao.get(idSubasta);
		
		if (Checks.esNulo(subasta)) return false;
		
		return Checks.esNulo(subasta.getResultadoComite()) ? false : true;
	}

	private Long restaFechas(Date fechaMenor, Date fechaMayor) {
		long in = fechaMayor.getTime();
		long fin = fechaMenor.getTime();
		return (fin - in) / (1000 * 60 * 60 * 24);

	}
	
	@BusinessOperation(BO_NMB_SUBASTA_GET_BIENES_SUBASTA)
	public List<Bien> getBienesSubasta(Long idSubasta){
		Subasta subasta = subastaDao.get(idSubasta);
		List<LoteSubasta> lotes = subasta.getLotesSubasta();
		List<Bien> bienes = new ArrayList<Bien>();
		if (lotes != null) {
			for(LoteSubasta l : lotes){
				bienes.addAll(l.getBienes());
			}
		}
		return bienes;
	}
	
	@BusinessOperation(BO_NMB_SUBASTA_GET_DATOS_ACTA_COMITE)
	public List<DatosActaComiteBean> getDatosActaComite(NMBDtoBuscarLotesSubastas dto){
		
		java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("dd/MM/yyyy");
		
		//PBO:
		List<LoteSubasta> listaRetorno = subastaDao.buscarLoteSubastasExcel(dto);
		// Traspasa los resultados al DTO para calcular valores adicionales
		List<LoteSubastaMasivaDTO> lotesMasivo = normalizarResultadoLotesSubasta(listaRetorno);
		
		// Recorremos la lista de lotes y por cada lote obtenemos los bienes
		List<Bien> bienesList = new ArrayList<Bien>();
		List<DatosActaComiteBean> datosActaComite = new ArrayList<DatosActaComiteBean>();
		
		for (LoteSubastaMasivaDTO ls : lotesMasivo) {
			LoteSubasta lote = ls.getLoteSubasta();
			bienesList = lote.getBienes();
			
			// Recorremos los bienes y por cada bien construimos un objeto a mostrar
			// en el informe del Acta de Comité
			for (Bien bien : bienesList) {
				DatosActaComiteBean dActaComite = new DatosActaComiteBean();
				
				String operacion = "";
				if (lote.getSubasta().getContratoGeneral() != null) {
					operacion = lote.getSubasta().getContratoGeneral().getDescripcion();
				}
				dActaComite.setOperacion(operacion);
				
				Date fechaSenyal = lote.getSubasta().getFechaSenyalamiento();
				String fechaSenyalString = "";
				if (fechaSenyal != null) {
					fechaSenyalString = sdf.format(lote.getSubasta().getFechaSenyalamiento());
				}
				dActaComite.setFechaSubasta(fechaSenyalString);
				
				String centroGestor = "";
				if (ls.getCentroGestorString() != null) {
					centroGestor = ls.getCentroGestorString();
				}
				dActaComite.setCentroGestor(centroGestor);
				
				String oficina = "";
				if (lote.getSubasta().getContratoGeneral() != null) {
					oficina = lote.getSubasta().getContratoGeneral().getOficina().getCodigo().toString();
				}
				dActaComite.setOficina(oficina);
				
				Float tipoSubasta = 0F;
				if (bien instanceof NMBBien) {
					tipoSubasta = ((NMBBien)bien).getTipoSubasta();
				}
				dActaComite.setTipo(tipoSubasta);
				
				String numeroActivo = "";
				if (bien instanceof NMBBien) {
					numeroActivo = ((NMBBien)bien).getNumeroActivo();
				}
				dActaComite.setActivo(numeroActivo);
				
				dActaComite.setDeudaJuzgado(noNullFloat(lote.getDeudaJudicial()));
				dActaComite.setSinPostores(noNullFloat(lote.getInsPujaSinPostores()));
				dActaComite.setConPostoresMin(noNullFloat(lote.getInsPujaPostoresDesde()));
				dActaComite.setConPostoresMax(noNullFloat(lote.getInsPujaPostoresHasta()));
				dActaComite.setTasacion(noNullFloat(lote.getTasacionActiva()));
				
				datosActaComite.add(dActaComite);
			}
		}
		
		return datosActaComite;
	}

	private Float noNullFloat(Float valor) {
		if (valor == null) {
			return new Float(0);
		} else {
			return valor;
		}
	}
	
	@Override
	public List<DynamicElement> getTabs(long idSubasta) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<DynamicElement> getButtons(long idSubasta) {
		// TODO Auto-generated method stub
		return null;
	}
	
	/**
	 * Método para buscar subastas según filtros indicados en el DTO.
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarSubastas")
	@Transactional
	public Page buscarSubastas(NMBDtoBuscarSubastas dto) {
		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		List<Subasta> listaRetorno = new ArrayList<Subasta>();
		PageHibernate page = (PageHibernate) subastaDao.buscarSubastasPaginados(dto, usuarioLogado);
		if (page != null) {
			listaRetorno.addAll((List<Subasta>) page.getResults());
			// TODO: Quitar lo comentado tras un tiempo de pruebas
/*			En caso de estar enlazada con LAZY hay que poner esto...
 			for (Subasta subasta : listaRetorno) {
				Asunto asunto = subasta.getAsunto();
				if (Hibernate.getClass(asunto).equals(EXTAsunto.class)) {
	                HibernateProxy proxy = (HibernateProxy) asunto;
	                EXTAsunto extAsunto = ((EXTAsunto) proxy.writeReplace());
	                subasta.setAsunto(extAsunto);
	            } 
			}*/
			page.setResults(listaRetorno);
		}
		return page;
	}	
	
	/**
	 * Método para buscar subastas según filtros indicados en el DTO para EXCEL.
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarSubastasXLS")
	@Transactional
	public FileItem buscarSubastasXLS(NMBDtoBuscarSubastas dto) {
		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		List<Subasta> listaRetorno = subastaDao.buscarSubastasExcel(dto, usuarioLogado);
		
		return generarInformeBusquedaSubastas(listaRetorno);		
	}			
	
	@SuppressWarnings("unchecked")
	@BusinessOperation("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarTareasSubastaBankia")
	@Transactional
	public List<TareaProcedimiento> buscarTareasSubastaBankia() {

		//TODO - Revisar este método para Haya		
		//Busco el tipo de procedimiento de la subasta de Bankia
		TipoProcedimiento procedimientoBankia = genericDao.get(TipoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TIPO_PROCEDIMIENTO_SUBASTA_BANKIA));
		if (!Checks.esNulo(procedimientoBankia)) {
			//Busco las tareas del tipo de procedimiento de Bankia
			return genericDao.getList(TareaProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento", procedimientoBankia));
		} else {
			return new ArrayList<TareaProcedimiento>();
		}
	}	
	
	@SuppressWarnings("unchecked")
	@BusinessOperation("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarTareasSubastaSareb")
	@Transactional	
	public List<TareaProcedimiento> buscarTareasSubastaSareb() {
		
		//TODO - Revisar este método para Haya		
		//Busco el tipo de procedimiento de la subasta de Sareb		
		TipoProcedimiento procedimientoSareb = genericDao.get(TipoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TIPO_PROCEDIMIENTO_SUBASTA_SAREB));
		if (!Checks.esNulo(procedimientoSareb)) {
			//Busco las tareas del tipo de procedimiento de Sareb
			return genericDao.getList(TareaProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento", procedimientoSareb));		
		} else {
			return new ArrayList<TareaProcedimiento>();
		}
		//Devuelvo todas las tareas juntas, ya que se podrán diferenciar por el DD_TPO_ID (tipo de procedimiento)
	}	
	
	/**
	 * Recupera los bienes de una subasta.
	 * 
	 * @param idSubasta
	 *            Long
	 * @return lista de bienes.
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarBienesDeUnaSubasta")
	public List<NMBBien> getBienesDeUnaSubasta(Subasta subasta) {
		
		//Busco los lotes de una subasta
		List<LoteSubasta> lotesSubasta = new ArrayList<LoteSubasta>();
		lotesSubasta = genericDao.getList(LoteSubasta.class, genericDao.createFilter(FilterType.EQUALS, "subasta", subasta));
		
		List<NMBBien> resultadoTotalBienes = new ArrayList<NMBBien>();
		
		for (int i=0; i<lotesSubasta.size();i++){
			//Busco los bienes por lote
			
			List<LoteBien> lotesDeBienes = new ArrayList<LoteBien>();
			lotesDeBienes = genericDao.getList(LoteBien.class, genericDao.createFilter(FilterType.EQUALS, "loteSubasta", lotesSubasta.get(i)));
			
			for (int j=0; j<lotesDeBienes.size();j++){
				List<NMBBien> bienesPorLote = new ArrayList<NMBBien>();
				bienesPorLote = genericDao.getList(NMBBien.class, genericDao.createFilter(FilterType.EQUALS, "bien", lotesDeBienes.get(j).getBien() ));
				
				for(int k=0;k<bienesPorLote.size();k++){
					resultadoTotalBienes.add(bienesPorLote.get(k));
				}
			}
			
		}		
		return resultadoTotalBienes;
	}	
	
	private String booleanToString(boolean valor){
		if (valor){
			return "S";
		}
		else{
			return "N";
		}
	}
	
	private String dateToString(Date fecha){
		String resultado = "";
		
		if (fecha!=null){
			java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("dd/MM/yyyy");
			resultado = sdf.format(fecha);
		}		
		
		return resultado;
	}
	
	private String floatToString(Float valor) {
		return (valor!=null) ? valor.toString() : "";
	}

	private String integerToString(Integer valor) {
		return (valor!=null) ? valor.toString() : "";
	}

	private String longToString(Long valor) {
		return (valor!=null) ? valor.toString() : "";
	}
	
	//Formatea las String introducidas que desean verse correctamente en la hoja excel
	private String formatearString(String texto){
		
		texto = texto.replace("ñ", "\u00f1");
		texto = texto.replace("Ñ", "\u00d1");
		
		texto = texto.replace("á", "\u00e1");
		texto = texto.replace("é", "\u00e9");
		texto = texto.replace("í", "\u00ed");
		texto = texto.replace("ó", "\u00f3");
		texto = texto.replace("ú", "\u00fa");
		
		texto = texto.replace("Á", "\u00c1");
		texto = texto.replace("É", "\u00c9");
		texto = texto.replace("Í", "\u00cd");
		texto = texto.replace("Ó", "\u00d3");
		texto = texto.replace("Ú", "\u00da");
		
		return texto;
	}

	/**
	 * Balanceador para generar distintos tipos de archivos con la b�squeda de subastas
	 * @param listaSubastas
	 * @return
	 */
	private FileItem generarInformeBusquedaSubastas(List<Subasta> listaSubastas){
		String exportFileType = !Checks.esNulo(appProperties.getProperty("exportar.filetype.buscadorSubastas")) ? 
				appProperties.getProperty("exportar.filetype.buscadorSubastas") : "CSV";
		try {
			if(exportFileType.equalsIgnoreCase("XLS")){
				return generarInformeBusquedaSubastasXLS(listaSubastas);
			}else{
				return generarInformeBusquedaSubastasCSV(listaSubastas);				
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error(e);
		}
		return null;
	}

	private ArrayList<String> getListaCabecera(){
		
		ArrayList<String> cabeceras = new ArrayList<String>();
		
		//Cabecera de las columnas
		cabeceras.add(formatearString("Asunto"));
		cabeceras.add(formatearString("N.Autos"));
		cabeceras.add(formatearString("F.Solicitud"));
		cabeceras.add(formatearString("F.Anuncio"));		
		cabeceras.add(formatearString("F.Señalamiento"));		
		cabeceras.add(formatearString("Estado"));
		cabeceras.add(formatearString("Tasación"));
		cabeceras.add(formatearString("Embargo"));
		cabeceras.add(formatearString("Inf.Letrado"));
		cabeceras.add(formatearString("Instrucciones"));
		cabeceras.add(formatearString("Subasta Revisada"));
		cabeceras.add(formatearString("Total cargas anteriores"));		
		cabeceras.add(formatearString("Total importe adjudicado"));
		cabeceras.add(formatearString("Codigo externo"));
		cabeceras.add(formatearString("Propiedad"));
		cabeceras.add(formatearString("Gestion"));
		cabeceras.add(formatearString("Plaza"));
		cabeceras.add(formatearString("Juzgado"));
		cabeceras.add(formatearString("Despacho"));
		cabeceras.add(formatearString("Procurador"));
		
		return cabeceras;
	}
	
	/**
	 * Genera un archivo de texto UTF8, con separadores de columna y que lleva el resultado de la b�squeda de subastas
	 * @param listaSubastas
	 * @return
	 */
	private FileItem generarInformeBusquedaSubastasCSV(List<Subasta> listaSubastas) throws Exception {
		String nombreFichero = (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + "-listadoBusquedaSubastas.csv";
		String rutaCompletaFichero = !Checks.esNulo(appProperties.getProperty("files.temporaryPath")) ? 
				appProperties.getProperty("files.temporaryPath") : "";
		rutaCompletaFichero += File.separator.equals(rutaCompletaFichero.substring(rutaCompletaFichero.length()-1)) || rutaCompletaFichero.length() == 0 ? nombreFichero : File.separator+nombreFichero;

		List<String> cabeceras = new ArrayList<String>();
		String cabecerasRegCSV = new String();
		String datosSubastasRegCSV = new String();
		
        FileWriter fstream = new FileWriter(rutaCompletaFichero, false);
        BufferedWriter out = new BufferedWriter(fstream);
        
		//Cabecera de las columnas
		cabeceras = getListaCabecera();
		
		//Carga las cabeceras en un registro para archivos CSV
		for (int i=0; i<cabeceras.size(); i++) {
        	cabecerasRegCSV += cabeceras.get(i) + ",";
        }
        
        //Escribe las cabeceras en el archivo CSV
		out.write(cabecerasRegCSV);
		out.newLine();
		
		//Lista todos los registros de Subastas y los carga en registros para archivos CSV
		for (Subasta subasta : listaSubastas) {
			if(!Checks.esNulo(subasta.getAsunto())){
				datosSubastasRegCSV = (Checks.esNulo(subasta.getAsunto().getNombre())? "" :  subasta.getAsunto().getNombre().replaceAll(",",".")) + ",";
			} else {
				datosSubastasRegCSV = ",";
			}
			if(!Checks.esNulo(subasta.getProcedimiento())){
				datosSubastasRegCSV += (Checks.esNulo(subasta.getProcedimiento().getCodigoProcedimientoEnJuzgado())? "" : subasta.getProcedimiento().getCodigoProcedimientoEnJuzgado()) + ",";
			} else {
				datosSubastasRegCSV = ",";				
			}
			//TODO - REVISAR EN BANKIA
			datosSubastasRegCSV += (Checks.esNulo(subasta.getFechaSolicitud())? "" : dateToString(subasta.getFechaSolicitud()) ) + ",";
			datosSubastasRegCSV += (Checks.esNulo(subasta.getFechaAnuncio())? "" : dateToString(subasta.getFechaAnuncio()) ) + ",";
			datosSubastasRegCSV += (Checks.esNulo(subasta.getFechaSenyalamiento())? "" : dateToString(subasta.getFechaSenyalamiento()) ) + ",";
			datosSubastasRegCSV += (Checks.esNulo(subasta.getEstadoSubasta().getDescripcion())? "" : subasta.getEstadoSubasta().getDescripcion().replaceAll(",",".")) + ",";
			//TODO -REVISAR EN BANKIA
			if(!Checks.esNulo(appProperties.getProperty(APPConstants.PROYECTO))){
				datosSubastasRegCSV += (booleanToString(subasta.isTasacion(appProperties.getProperty(APPConstants.PROYECTO))) ) + ",";
			} else{
				datosSubastasRegCSV += (Checks.esNulo(subasta.isTasacion())? "" : booleanToString(subasta.isTasacion())) + ",";
			}

			datosSubastasRegCSV += (Checks.esNulo(subasta.getEmbargo())? "" : booleanToString(subasta.getEmbargo()) ) + ",";
			datosSubastasRegCSV += (Checks.esNulo(subasta.isInfoLetrado())? "" : booleanToString(subasta.isInfoLetrado()) ) + ",";
			datosSubastasRegCSV += (Checks.esNulo(subasta.isInstrucciones())? "" : booleanToString(subasta.isInstrucciones()) ) + ",";
			datosSubastasRegCSV += (Checks.esNulo(subasta.isSubastaRevisada())? "" : booleanToString(subasta.isSubastaRevisada()) ) + ",";
			datosSubastasRegCSV += (Checks.esNulo(subasta.getCargasAnteriores())? "" : subasta.getCargasAnteriores()) + ",";				
			datosSubastasRegCSV += (Checks.esNulo(subasta.getTotalImporteAdjudicado())? "" : subasta.getTotalImporteAdjudicado()) + ",";
			
			EXTAsunto asunto = (EXTAsunto) subasta.getAsunto();			
			if (asunto!=null) {
				datosSubastasRegCSV += (Checks.esNulo(asunto.getCodigoExterno())? "" : asunto.getCodigoExterno()) + ",";
				datosSubastasRegCSV += (Checks.esNulo(asunto.getPropiedadAsunto())? "" : asunto.getPropiedadAsunto().getDescripcion().replaceAll(",",".")) + ",";
				datosSubastasRegCSV += (Checks.esNulo(asunto.getGestionAsunto())? "" : asunto.getGestionAsunto().getDescripcion().replaceAll(",",".")) + ",";
			} else {
				datosSubastasRegCSV += ",";
				datosSubastasRegCSV += ",";
				datosSubastasRegCSV += ",";
			}

			if (!Checks.esNulo(subasta.getProcedimiento()) && !Checks.esNulo(subasta.getProcedimiento().getJuzgado())){
				datosSubastasRegCSV += (Checks.esNulo(subasta.getProcedimiento().getJuzgado().getPlaza().getDescripcion())? "" : subasta.getProcedimiento().getJuzgado().getPlaza().getDescripcion().replaceAll(",",".")) + ",";
				datosSubastasRegCSV += (Checks.esNulo(subasta.getProcedimiento().getJuzgado().getDescripcion())? "" : subasta.getProcedimiento().getJuzgado().getDescripcion().replaceAll(",",".")) + ",";
			}else{
				datosSubastasRegCSV += ",";
				datosSubastasRegCSV += ",";				
			}
			if(!Checks.esNulo(subasta.getAsunto()) && !Checks.esNulo(subasta.getAsunto().getGestor())){
				datosSubastasRegCSV += (Checks.esNulo(subasta.getAsunto().getGestor().getDespachoExterno().getDescripcion())? "" : subasta.getAsunto().getGestor().getDespachoExterno().getDescripcion().replaceAll(",",".")) + ",";
			} else {
				datosSubastasRegCSV += ",";				
			}
			if(!Checks.esNulo(subasta.getAsunto()) && !Checks.esNulo(subasta.getAsunto().getProcurador())){
				datosSubastasRegCSV += (Checks.esNulo(subasta.getAsunto().getProcurador().getUsuario().getApellidoNombre())? "" : subasta.getAsunto().getProcurador().getUsuario().getApellidoNombre().replaceAll(",",".")) + ",";
			} else {
				datosSubastasRegCSV += ",";
			}

			//Almacena el nuevo registro en el archivo en disco
            out.write(datosSubastasRegCSV);
            out.newLine();
            out.flush();
             
		}
		
		//Almacena los registros que han quedado cacheados
		out.flush();
        fstream.flush();
        
        //Cierra archivos
		out.close();
        fstream.close();
        
        //Env�a el archivo generado temporalmente a trav�s del navegador
		File fCSV = new File(rutaCompletaFichero);
		FileItem fiCSV = new FileItem(fCSV);
		fiCSV.setFileName(rutaCompletaFichero);
		fiCSV.setContentType("text/csv");
		fiCSV.setLength(fCSV.length());
	
		return fiCSV;
	}
	
	private FileItem generarInformeBusquedaSubastasXLS(List<Subasta> listaSubastas) throws Exception{
		HojaExcel hojaExcel = new HojaExcel();
		
		String nombreFichero = (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + "-listadoBusquedaSubastas.xls";
		
		List<String> cabeceras = new ArrayList<String>();
		
		List<List<String>> valores = new ArrayList<List<String>>();

		//Cabecera de las columnas
		cabeceras = getListaCabecera();
		
		for (Subasta subasta : listaSubastas) {
			List<String> datosSubastas = new ArrayList<String>();
			datosSubastas.add(subasta.getAsunto().getNombre());
			datosSubastas.add(subasta.getProcedimiento().getCodigoProcedimientoEnJuzgado());
			//TODO - REVISAR EN BANKIA
			datosSubastas.add(dateToString(subasta.getFechaSolicitud()) );
			datosSubastas.add(dateToString(subasta.getFechaAnuncio()) );
			datosSubastas.add(dateToString(subasta.getFechaSenyalamiento()) );
			if(!Checks.esNulo(subasta.getEstadoSubasta())){
				datosSubastas.add(subasta.getEstadoSubasta().getDescripcion());
			} else {
				datosSubastas.add("");
			}
			//TODO -REVISAR EN BANKIA
			if(!Checks.esNulo(appProperties.getProperty(APPConstants.PROYECTO))){
				datosSubastas.add(booleanToString(subasta.isTasacion(appProperties.getProperty(APPConstants.PROYECTO))) );
			} else{
				datosSubastas.add(booleanToString(subasta.isTasacion()));
			}

			datosSubastas.add(booleanToString(subasta.getEmbargo()) );
			datosSubastas.add(booleanToString(subasta.isInfoLetrado()) );
			datosSubastas.add(booleanToString(subasta.isInstrucciones()) );
			datosSubastas.add(booleanToString(subasta.isSubastaRevisada()) );
			datosSubastas.add(subasta.getCargasAnteriores());				
			datosSubastas.add(subasta.getTotalImporteAdjudicado());
			
			EXTAsunto asunto = (EXTAsunto) subasta.getAsunto();			
			if (asunto!=null) {
				datosSubastas.add(asunto.getCodigoExterno()!=null?asunto.getCodigoExterno():"");
				datosSubastas.add(asunto.getPropiedadAsunto()!=null?asunto.getPropiedadAsunto().getDescripcion():"");
				datosSubastas.add(asunto.getGestionAsunto()!=null?asunto.getGestionAsunto().getDescripcion():"");
			} else {
				datosSubastas.add("");
				datosSubastas.add("");
				datosSubastas.add("");
			}
			if(!Checks.esNulo(subasta.getProcedimiento()) && !Checks.esNulo(subasta.getProcedimiento().getJuzgado())){				
				datosSubastas.add(subasta.getProcedimiento().getJuzgado().getDescripcion());
				if(!Checks.esNulo(subasta.getProcedimiento().getJuzgado().getPlaza())){
					datosSubastas.add(subasta.getProcedimiento().getJuzgado().getPlaza().getDescripcion());
				}else{
					datosSubastas.add("");
				}
			} else{
				datosSubastas.add("");
				datosSubastas.add("");
			}
			if(!Checks.esNulo(subasta.getAsunto())){
				if(!Checks.esNulo(subasta.getAsunto().getGestor()) && !Checks.esNulo(subasta.getAsunto().getGestor().getDespachoExterno())){				
					datosSubastas.add(subasta.getAsunto().getGestor().getDespachoExterno().getDescripcion());
				}else{
					datosSubastas.add("");
				}
				if(!Checks.esNulo(subasta.getAsunto().getProcurador()) && !Checks.esNulo(subasta.getAsunto().getProcurador().getUsuario())){				
					datosSubastas.add(subasta.getAsunto().getProcurador().getUsuario().getApellidoNombre());
				}else{
					datosSubastas.add("");
				}
			}else{
				datosSubastas.add("");
				datosSubastas.add("");
			}
			
			valores.add(datosSubastas);
		}
		
		String rutaCompletaFichero = !Checks.esNulo(appProperties.getProperty("files.temporaryPath")) ? 
				appProperties.getProperty("files.temporaryPath") : "";
		rutaCompletaFichero += File.separator.equals(rutaCompletaFichero.substring(rutaCompletaFichero.length()-1)) || rutaCompletaFichero.length() == 0 ? nombreFichero : File.separator+nombreFichero; 

		//Creo el fichero excel
		hojaExcel.crearNuevoExcel(rutaCompletaFichero, cabeceras, valores);
		
		
		FileItem excelFileItem = new FileItem(hojaExcel.getFile());
		excelFileItem.setFileName(rutaCompletaFichero);
		excelFileItem.setContentType(HojaExcel.TIPO_EXCEL);
		excelFileItem.setLength(hojaExcel.getFile().length());
		
		return excelFileItem;
	}
	
	@Override
	@BusinessOperation(BO_NMB_SUBASTA_INFORME_SUBASTA_LETRADO)
	public InformeSubastaLetradoBean getInformeSubastasLetrado(Long idSubasta) {
		//InformeSubastaLetradoBean informe = new InformeSubastaLetradoBean();
		
		InformeSubastaLetradoBean informe = genericDao.get(InformeSubastaLetradoBean.class, genericDao.createFilter(FilterType.EQUALS, "idSubasta", idSubasta));
		
		return informe;
	}

	@Override
	@BusinessOperation(BO_NMB_SUBASTA_GET_SUBASTA)
	public Subasta getSubasta(Long idSubasta) {		
		return subastaDao.get(idSubasta);
	}


	@BusinessOperation(BO_NMB_SUBASTA_GUARDA_ACUERDO_CIERRE)
	public void guardaBatchAcuerdoCierre(BatchAcuerdoCierreDeuda autoCierreDeuda) {
		genericDao.save(BatchAcuerdoCierreDeuda.class, autoCierreDeuda);
	}
	

	private List<LoteSubastaMasivaDTO> normalizarResultadoLotesSubasta(List<LoteSubasta> listado) {
		List<LoteSubastaMasivaDTO> lotesMasivo = new ArrayList<LoteSubastaMasivaDTO>();
		for (LoteSubasta lote : listado) {
			LoteSubastaMasivaDTO dtoMasivo = new LoteSubastaMasivaDTO();
			dtoMasivo.setLoteSubasta(lote);
			lotesMasivo.add(dtoMasivo);
			Contrato contrato = lote.getSubasta().getContratoGeneral();
			if (contrato==null || contrato.getOficina()==null) {
				continue;
			}
			Oficina oficina = contrato.getOficina();
			Long idZonaOficina = oficina.getZona().getId();
			Long idNivelZonaPadreInformes = projectContext.getNivelZonaOficinaGestoraEnInformes();
			Oficina centroGestor = oficinaDao.dameAscendientesDirectoAPartirDeNivel(idZonaOficina, idNivelZonaPadreInformes);
			dtoMasivo.setCentroGestor(centroGestor);
		}
		return lotesMasivo;
	}
	
	/**
	 * Método para buscar subastas según filtros indicados en el DTO.
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation(BO_NMB_SUBASTA_BUSCAR_LOTES_SUBASTA)
	@Transactional
	public Page buscarLotesSubastas(NMBDtoBuscarLotesSubastas dto) {
		//Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		
		PageHibernate page = null;
		// Para Lotes subasta recupera todos los valores
		page = (PageHibernate) subastaDao.buscarLotesSubastasPaginados(dto);

		// Traspasa los resultados al DTO para calcular valores adicionales
		List<LoteSubasta> lotes = (List<LoteSubasta>)page.getResults();
		List<LoteSubastaMasivaDTO> lotesMasivo = normalizarResultadoLotesSubasta(lotes);
		page.setResults(lotesMasivo);
		
		return page;
	}	
	
	@Override
	@BusinessOperation(BO_NMB_SUBASTA_BUSCAR_LOTES_SUBASTA_EXCEL)
	public FileItem buscarLotesSubastasXLS(NMBDtoBuscarLotesSubastas dto) {
		//Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		List<LoteSubasta> listaRetorno = subastaDao.buscarLoteSubastasExcel(dto);
		// Traspasa los resultados al DTO para calcular valores adicionales
		List<LoteSubastaMasivaDTO> lotesMasivo = normalizarResultadoLotesSubasta(listaRetorno);
		return generarInformeBusquedaLoteSubastas(lotesMasivo);		
	}			

	@Override
	@BusinessOperation(BO_NMB_SUBASTA_PASAR_LOTES_TRAS_PROPUESTO)
	public void marcarLotesEstadoTrasPropuesta(Subasta subasta) {
		List<LoteSubasta> lotes = subasta.getLotesSubasta();
		// Las subastas DELEGADAS los lotes se aprueban directamente. 
		String codigo = (DDTipoSubasta.DEL.equals(subasta.getTipoSubasta().getCodigo())) ? DDEstadoLoteSubasta.APROBADA : DDEstadoLoteSubasta.PROPUESTA;
		DDEstadoLoteSubasta estado = (DDEstadoLoteSubasta)diccionarioApi.dameValorDiccionarioByCod(DDEstadoLoteSubasta.class, codigo);
		for (LoteSubasta lote : lotes) {
			// Sólo cambia los lotes en estado conformado.
			if (!DDEstadoLoteSubasta.CONFORMADA.equals(lote.getEstado().getCodigo()) && !DDEstadoLoteSubasta.DEVUELTA.equals(lote.getEstado().getCodigo())) {
				continue;
			}
			lote.setEstado(estado);
			lote.setFechaEstado(new Date());
			genericDao.update(LoteSubasta.class, lote);
		}
	}			
	
	@BusinessOperation(BO_NMB_SUBASTA_PASAR_LOTES_TRAS_VALIDAR)
	public void marcarLotesEstadoTrasValidar(Subasta subasta, TareaExterna tarea, String decision) {
		List<LoteSubasta> lotes = subasta.getLotesSubasta();
		List<EXTTareaExternaValor> listadoTareaExternaValor = ((SubastaProcedimientoApi) proxyFactory.proxy(SubastaProcedimientoApi.class)).obtenerValoresTareaByTexId(tarea.getId());
		for (LoteSubasta lote : lotes) {
			projectContext.actualizaLoteSubastaSegunInformacionTarea(lote, listadoTareaExternaValor, decision);
			genericDao.update(LoteSubasta.class, lote);
		}
	}

	private FileItem generarInformeBusquedaLoteSubastas(List<LoteSubastaMasivaDTO> listaSubastas){
		HojaExcel hojaExcel = new HojaExcel();
		
		String nombreFichero = (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + "-listadoBusquedaLotesSubastas.xls";
		
		List<String> cabeceras = new ArrayList<String>();
		
		List<List<String>> valores = new ArrayList<List<String>>();
		
		//Cabecera de las columnas
		cabeceras.add(formatearString("Nº Operacion"));
		cabeceras.add(formatearString("Fecha Subasta"));
		cabeceras.add(formatearString("Oficina"));		
		cabeceras.add(formatearString("Centro Gestor"));		
		cabeceras.add(formatearString("Tipo Subasta"));
		cabeceras.add(formatearString("Deuda Judicial"));
		cabeceras.add(formatearString("Puja sin postores"));
		cabeceras.add(formatearString("Puja con postores desde"));
		cabeceras.add(formatearString("Puja con postores hasta"));
		cabeceras.add(formatearString("Nº Activos"));
		cabeceras.add(formatearString("Tasación activa"));
		cabeceras.add(formatearString("Riesgo consignación"));
		cabeceras.add(formatearString("Cargas"));
		cabeceras.add(formatearString("Estado"));
		
		for (LoteSubastaMasivaDTO lote : listaSubastas) {
			List<String> datosSubastas = new ArrayList<String>();
			datosSubastas.add(lote.getLoteSubasta().getSubasta().getContratoGeneral() !=null ? lote.getLoteSubasta().getSubasta().getContratoGeneral().getDescripcion() : "");
			datosSubastas.add(dateToString(lote.getLoteSubasta().getSubasta().getFechaSenyalamiento()));
			datosSubastas.add(lote.getLoteSubasta().getSubasta().getContratoGeneral()!= null ? longToString(lote.getLoteSubasta().getSubasta().getContratoGeneral().getCodigoOficina()) : "");
			datosSubastas.add(lote.getCentroGestorString());				
			datosSubastas.add(floatToString(lote.getLoteSubasta().getValorBienes()));
			datosSubastas.add(floatToString(lote.getLoteSubasta().getDeudaJudicial()));
			datosSubastas.add(floatToString(lote.getLoteSubasta().getInsPujaSinPostores()));
			datosSubastas.add(floatToString(lote.getLoteSubasta().getInsPujaPostoresDesde()));
			datosSubastas.add(floatToString(lote.getLoteSubasta().getInsPujaPostoresHasta()));
			datosSubastas.add(integerToString(lote.getLoteSubasta().getBienes().size()));
			datosSubastas.add(floatToString(lote.getLoteSubasta().getTasacionActiva()));
			datosSubastas.add(booleanToString(lote.getLoteSubasta().getRiesgoConsignacion()));
			datosSubastas.add(booleanToString(lote.getLoteSubasta().getTieneCargasAnteriores()));
			datosSubastas.add(lote.getLoteSubasta().getEstado().getDescripcion());
			valores.add(datosSubastas);
		}
		
		String rutaCompletaFichero = !Checks.esNulo(appProperties.getProperty("files.temporaryPath")) ? 
				appProperties.getProperty("files.temporaryPath") : "";
		rutaCompletaFichero += File.separator.equals(rutaCompletaFichero.substring(rutaCompletaFichero.length()-1)) || rutaCompletaFichero.length() == 0 ? nombreFichero : File.separator+nombreFichero; 

		//Creo el fichero excel
		hojaExcel.crearNuevoExcel(rutaCompletaFichero, cabeceras, valores);
		
		
		FileItem excelFileItem = new FileItem(hojaExcel.getFile());
		excelFileItem.setFileName(rutaCompletaFichero);
		excelFileItem.setContentType(HojaExcel.TIPO_EXCEL);
		excelFileItem.setLength(hojaExcel.getFile().length());
		
		return excelFileItem;
	}

	//M�todo que calcula si se puede mostrar el bot�n de solicitar tasaci�n
	@BusinessOperation(BO_NMB_SUBASTA_PERMITE_SOLICITAR_TASACION)
	public Integer permiteSolicitarTasacion(Long id){
			
			try{
			Integer flag = 1;
			
			//Obtenemos el Bien
			NMBBien bien = nmbBienDao.get(id);
			
			//Obtenemos la subasta 
			Subasta subasta = null;
			List<Subasta> listaSubastas = subastaDao.getSubastasporIdBien(id);	
			if(listaSubastas != null && listaSubastas.size()!=0){
				for(Subasta s : listaSubastas){
					if(subasta!=null){
						if(s.getFechaSenyalamiento()!=null && subasta.getFechaSenyalamiento()!=null){
							if(s.getFechaSenyalamiento().after(subasta.getFechaSenyalamiento())){
							subasta = s;
							}
						}
						else{
							if(subasta.getFechaSenyalamiento()==null && s.getFechaSenyalamiento()!=null){
								subasta = s;
							}
						}	
					}
					else{
						subasta = s;
					}
				}
			}
			//-1 --> No se permite solicitar tasaci�n, el bien no est� en ninguna subasta o la subasta no tiene fecha de se�alamiento
			if(subasta == null || subasta.getFechaSenyalamiento() == null){
				flag=-1;
			}
			else{
				GregorianCalendar g1 = new GregorianCalendar();
				GregorianCalendar g2 = new GregorianCalendar();//fecha actual
				NMBValoracionesBienInfo valoracion = bien.getValoracionActiva(); 
				
				//Calculamos la diferencia en meses entre la fecha actual y la fecha de celebraci�n de subasta
				Integer calculoDifSubasta = null;
				if(subasta.getFechaSenyalamiento()!=null){
					g1.setTime(subasta.getFechaSenyalamiento());
					calculoDifSubasta = getMonths(g2, g1);	
				}		
				
				 //Calculamos  la diferencia entre la fecha actual y la fecha de valor tasaci�n
				Integer calculoDifTasacion = null;
				if(valoracion!=null && valoracion.getFechaValorTasacion()!=null){
					 g1.setTime(valoracion.getFechaValorTasacion());
					 calculoDifTasacion = getMonths(g1, g2);	
				}
				
				//-2 --> No se permite solicitar tasaci�n, quedan m�s de 3 meses para la celebraci�n de la subasta
				if(calculoDifSubasta!=null && calculoDifSubasta>=3){
					flag = -2;
				}	
				else{
					//-3 --> No se permite solicitar tasaci�n, existe una solicitud de tasaci�n en curso
					if(calculoDifSubasta!=null && calculoDifSubasta<3 && valoracion.getCodigoNuita()!=null && valoracion.getFechaValorTasacion() == null){
						flag = -3;
					}
					else{
						
						// -4 --> No se permite solicitar tasaci�n, existe una tasaci�n de menos de 3 meses de antig�edad
						if(calculoDifSubasta!=null && calculoDifSubasta<3 && valoracion.getCodigoNuita()!=null && calculoDifTasacion!=null && calculoDifTasacion < 3 ){
							flag = -4;
						}
						
						//-5 --> No se permite solicitar tasaci�n, existe una tasaci�n de menos de 3 meses de antig�edad
						if(calculoDifSubasta!=null && calculoDifSubasta<3 && valoracion.getCodigoNuita()==null && calculoDifTasacion!=null && calculoDifTasacion < 3){
							flag = -5;
						}
					}
				}
			
			}
			
			return flag;
			}catch(Exception e){
				logger.error("SubastaManager.permiteSolicitarTasacion "+e);
				return 0;
			}
		}
		
		//devuelve -1 si la primera fecha es posterior
		//Sino, devuelve la diferencia de meses entre las dos fechas 
		private Integer getMonths(GregorianCalendar g1, GregorianCalendar g2) {
			
			int elapsed = -1; // Por defecto estaba en 0 y siempre asi no haya pasado un mes contaba 1)
			GregorianCalendar gc1 = new GregorianCalendar(g1.get(Calendar.YEAR), g1.get(Calendar.MONTH), g1.get(Calendar.DAY_OF_MONTH));
			GregorianCalendar gc2 = new GregorianCalendar(g2.get(Calendar.YEAR), g2.get(Calendar.MONTH), g2.get(Calendar.DAY_OF_MONTH));
			
			while ( gc1.before(gc2) ) {
			gc1.add(Calendar.MONTH, 1);
			elapsed++;
			}

			if (gc1.get(Calendar.DATE)==gc2.get(Calendar.DATE) && gc1.get(Calendar.MONTH)==gc2.get(Calendar.MONTH) && gc1.get(Calendar.YEAR)==gc2.get(Calendar.YEAR)) elapsed++; // si es el mismo dia cuenta para la suma de meses
			return elapsed;
		}

		@Override
		@BusinessOperation(BO_NMB_SUBASTA_EXPORTAR_BUSCADOR_SUBASTAS_EXCEL_COUNT)
		public Integer buscarSubastasXLSCount(NMBDtoBuscarSubastas dto) {
			Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
						
			return  subastaDao.buscarSubastasExcelCount(dto, usuarioLogado);	
		}
	
}
