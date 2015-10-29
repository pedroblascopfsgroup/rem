package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.manager;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.HtmlUtils;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.oficina.dao.OficinaDao;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.InformeValidacionCDDDto;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dao.SubastaDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.AcuerdoCierreDeudaDto;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarLotesSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchAcuerdoCierreDeuda;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchCDDResultadoNuse;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoLoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoValidacionCDD;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoValidacionNuse;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDTipoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteBien;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContext;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBValoracionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.dao.NMBBienDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.DatosActaComiteBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.InformeSubastaLetradoBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.ProcedimientoApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.SubastaApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.BienSubastaDTO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.EditarInformacionCierreDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.GuardarInstruccionesDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.LoteSubastaMasivaDTO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.masivas.SubastaInstMasivasValidacionDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.masivas.SubastanInstMasivasUtils;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimiento;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.DDPropiedadAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;


@Service("subastaManager")
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

	@Resource
    private MessageService messageService;	

	@Autowired
	private SubastanInstMasivasUtils masivasUtils;
	
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
	@Transactional(readOnly = false)
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
	@Transactional(readOnly = false)
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
	@Transactional(readOnly = false)
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
	
	@BusinessOperation(BO_NMB_SUBASTA_GET_BIENES_LOTE_SUBASTA)
	public List<Bien> getBienesLoteSubasta(Long idLote){
		LoteSubasta loteSubasta = genericDao.get(LoteSubasta.class, genericDao.createFilter(FilterType.EQUALS, "id", idLote), 
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		return loteSubasta.getBienes();
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
	
	@Override
	@BusinessOperation(BO_NMB_SUBASTA_PARAMETRIZAR_LIMITE)
	public Parametrizacion parametrizarLimite(String nombreParametro) {
		return (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
				nombreParametro);
	}	

	/**
	 * Metodo optimizado de busqueda de subastas para exportar a excel 
	 */
	@BusinessOperation("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarSubastasXLS")
	public FileItem buscarSubastasXLS(NMBDtoBuscarSubastas dto) {
		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);

		Parametrizacion parametroLimite = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
				Parametrizacion.LIMITE_EXPORT_EXCEL_BUSCADOR_SUBASTAS);

		List<HashMap<String, Object>> resultadoCount = subastaDao.buscarSubastasExcel(dto, usuarioLogado, true);

		if (resultadoCount.size() > 0) {
			Integer numRegistrosExportar = (Integer) resultadoCount.get(0).get("count");
			Integer limite = Integer.parseInt(parametroLimite.getValor());

			if (numRegistrosExportar > limite) {
				throw new UserException(messageService.getMessage("plugin.coreextension.asuntos.exportarExcel.limiteSuperado1") + limite + " "
						+ messageService.getMessage("plugin.coreextension.asuntos.exportarExcel.limiteSuperado2"));
			}
		}

		List<HashMap<String, Object>> resultadosExportar = subastaDao.buscarSubastasExcel(dto, usuarioLogado, false);

		return generarInformeBusquedaSubastas(resultadosExportar);
	}
	
	@SuppressWarnings("unchecked")
	@BusinessOperation("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.buscarTareasSubastaBankia")
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
	private FileItem generarInformeBusquedaSubastas(List<HashMap<String, Object>> listaSubastas){
		List<List<String>> valores = new ArrayList<List<String>>();

		for (HashMap<String, Object> row : listaSubastas) {
			List<String> filaExportar = new ArrayList<String>();

			filaExportar.add(ObjectUtils.toString(row.get("nombre"))); 						// Asunto
			filaExportar.add(ObjectUtils.toString(row.get("nAutos")));						// N.Autos
			filaExportar.add(ObjectUtils.toString(row.get("fechaSolicitud")));				// F.Solicitud
			filaExportar.add(ObjectUtils.toString(row.get("fechaAnuncio")));				// F.Anuncio
			filaExportar.add(ObjectUtils.toString(row.get("fechaSenyalamiento")));			// F.Señalamiento
			filaExportar.add(ObjectUtils.toString(row.get("estadoSubastaDescripcion")));	// Estado
			filaExportar.add(ObjectUtils.toString(row.get("tasacion")));					// Tasación
			filaExportar.add(ObjectUtils.toString(row.get("embargo")));						// Embargo
			filaExportar.add(ObjectUtils.toString(row.get("infoLetrado")));					// Inf.Letrado
			filaExportar.add(ObjectUtils.toString(row.get("instrucciones")));				// Instrucciones
			filaExportar.add(ObjectUtils.toString(row.get("subastaRevisada")));				// Subasta Revisada
			filaExportar.add(ObjectUtils.toString(row.get("cargasAnteriores")));			// Total cargas anteriores
			filaExportar.add(ObjectUtils.toString(row.get("totalImporteAdjudicado"))); 		// Total importe adjudicado
			filaExportar.add(ObjectUtils.toString(row.get("codigoExterno")));				// Codigo externo
			filaExportar.add(ObjectUtils.toString(row.get("propiedadAsunto")));				// Propiedad
			filaExportar.add(ObjectUtils.toString(row.get("gestionAsunto")));				// Gestion
			filaExportar.add(ObjectUtils.toString(row.get("plaza")));						// Plaza
			filaExportar.add(ObjectUtils.toString(row.get("juzgado")));						// Juzgado

			EXTAsunto asunto = null;
			if (row.get("asunto") != null) {
				asunto = (EXTAsunto) row.get("asunto");
			}

			if (asunto != null && asunto.getGestor() != null && asunto.getGestor().getDespachoExterno()!=null) {
				filaExportar.add(ObjectUtils.toString(asunto.getGestor().getDespachoExterno().getDespacho()));		// Despacho gestor
			} else {
				filaExportar.add("");
			}

			if (asunto != null && asunto.getProcurador() != null && asunto.getProcurador().getUsuario() != null) {
				filaExportar.add(ObjectUtils.toString(asunto.getProcurador().getUsuario().getApellidoNombre()));	// Procurador
			} else {
				filaExportar.add("");
			}

			valores.add(filaExportar);
		}

		String nombreFichero = (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + "-listadoBusquedaSubastas.xls";
		String rutaCompletaFichero = !Checks.esNulo(appProperties.getProperty("files.temporaryPath")) ? appProperties.getProperty("files.temporaryPath") : "";

		rutaCompletaFichero += File.separator.equals(rutaCompletaFichero.substring(rutaCompletaFichero.length()-1)) || rutaCompletaFichero.length() == 0 ? nombreFichero : File.separator+nombreFichero; 

		//Creo el fichero excel
		HojaExcel hojaExcel = new HojaExcel();
		hojaExcel.crearNuevoExcel(rutaCompletaFichero, getListaCabecera(), valores);

		FileItem excelFileItem = new FileItem(hojaExcel.getFile());
		excelFileItem.setFileName(rutaCompletaFichero);
		excelFileItem.setContentType(HojaExcel.TIPO_EXCEL);
		excelFileItem.setLength(hojaExcel.getFile().length());

		return excelFileItem;
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
	
	@BusinessOperation(BO_NMB_SUBASTA_GUARDA_ACUERDO_CIERRE_DEUDA)
	@Transactional(readOnly = false)
	public void guardaBatchAcuerdoCierreDeuda(BatchAcuerdoCierreDeuda autoCierreDeuda) {
		genericDao.save(BatchAcuerdoCierreDeuda.class, autoCierreDeuda);
	}

	@BusinessOperation(BO_NMB_SUBASTA_GUARDA_ACUERDO_CIERRE)
	@Transactional(readOnly = false)
	public void guardaBatchAcuerdoCierre(Long asuId, Long prcId, Long bienId, Long resultadoValidacion, DDResultadoValidacionCDD motivoValidacion, String origen) {
		BatchAcuerdoCierreDeuda autoCierreDeuda = getCierreDeudaInstance(asuId, prcId, bienId, resultadoValidacion, motivoValidacion, origen);
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
	@Transactional(readOnly = false)
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
	@Transactional(readOnly = false)
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
	//FIXME Oscar: creo que este método no funciona por culpa de la llamada getSubastasporIdBien
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
			return  subastaDao.buscarSubastasExcel(dto, usuarioLogado,true).size();	
		}
		
		@Override
		@BusinessOperation(BO_NMB_SUBASTA_OBTENER_TAREAS_CIERRE_DEUDA)
		public Map<String, String> obtenerTareasCierreDeuda() {
			 return projectContext.getTareasCierreDeuda();
		}
		
		@Override
		@Transactional(readOnly = false)
		@BusinessOperation(BO_NMB_SUBASTA_ACTUALIZAR_INFORMACION_CIERRE_DEUDA)
		public void actualizarInformacionCierreDeuda(EditarInformacionCierreDto dto) {
			Subasta subasta = subastaDao.get(Long.valueOf(dto.getIdSubasta()));
			TipoJuzgado tipoJuzgado = (TipoJuzgado) genericDao.get(TipoJuzgado.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoJuzgado()), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			tipoJuzgado.setPlaza(tipoJuzgado.getPlaza());
			subasta.getProcedimiento().setJuzgado(tipoJuzgado);
			subasta.getProcedimiento().setSaldoRecuperacion(dto.getPrincipalDemanda());
			subasta.setDeudaJudicial(dto.getDeudaJudicial());
			try {
				subasta.setFechaSenyalamiento(DateFormat.toDate(dto.getFechaSenyalamiento()));
			} catch (ParseException e) {
			}
			actualizarTareaExternaValor(dto.getIdValorCostasLetrado(), dto.getCostasLetrado());
			actualizarTareaExternaValor(dto.getIdValorCostasProcurador(), dto.getCostasProcurador());
			actualizarTareaExternaValor(dto.getIdValorConPostores(), dto.getConPostores());
			subastaDao.save(subasta);
		}
		
		private void actualizarTareaExternaValor(Long idValorNodoTarea, String valor) {
			TareaExternaValor tareaExtValor = (TareaExternaValor) genericDao.get(TareaExternaValor.class, 
					genericDao.createFilter(FilterType.EQUALS, "id", idValorNodoTarea),						
					genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			tareaExtValor.setValor(valor);
			genericDao.update(TareaExternaValor.class, tareaExtValor);
		}
		
		@Override
		@Transactional(readOnly = false)
		@BusinessOperation(BO_NMB_SUBASTA_TAREA_EXISTE_Y_FINALIZADA)
		public boolean tareaExisteYFinalizada(Procedimiento procedimiento, String nombreNodo) {
			HistoricoProcedimiento historicoPrc = getNodo(procedimiento, nombreNodo);
			return (!Checks.esNulo(historicoPrc) && !Checks.esNulo(historicoPrc.getFechaFin()));
		}
		
		@Override
		@Transactional(readOnly = false)
		@BusinessOperation(BO_NMB_SUBASTA_TAREA_EXISTE)
		public HistoricoProcedimiento tareaExiste(Procedimiento procedimiento, String nombreNodo) {
			return getNodo(procedimiento, nombreNodo);
		}
		
		@BusinessOperation(BO_NMB_SUBASTA_OBTENER_VALOR_NODO_PRC)
		public ValorNodoTarea obtenValorNodoPrc(Procedimiento procedimiento, String nombreNodo, String valor) {
			HistoricoProcedimiento historicoPrc = getNodo(procedimiento, nombreNodo);
			return getValorNodoPrc(historicoPrc, valor);
		}
		
		private HistoricoProcedimiento getNodo(Procedimiento procedimiento, String nombreNodo) {
			HistoricoProcedimiento hPrc = null;
			if ((!Checks.esNulo(procedimiento)) && (!Checks.esNulo(nombreNodo))) {
				List<EXTHistoricoProcedimiento> listadoTareasProc = proxyFactory.proxy(EXTHistoricoProcedimientoApi.class).getListByProcedimientoEXT(procedimiento.getId());			
				if (!Checks.esNulo(listadoTareasProc)) {
					for (EXTHistoricoProcedimiento hp : listadoTareasProc) {
						// Filtramos por el código de la tarea donde están los campos que
						// necesitamos y nos quedamos con el último
						if (!Checks.esNulo(hp.getCodigoTarea()) &&  nombreNodo.equals(hp.getCodigoTarea())) {
							hPrc = hp;
							//break;
						}
					}
				}
			}
			return hPrc;
		}
		
		private ValorNodoTarea getValorNodoPrc(HistoricoProcedimiento hPrc, String valor) {
			// Si hemos encontrado una tarea del tipo especificado
			if (!Checks.esNulo(hPrc) && !Checks.esNulo(valor)) {
				if (!Checks.esNulo(hPrc.getIdEntidad())) {
					TareaNotificacion tareaSS = proxyFactory.proxy(TareaNotificacionApi.class).get(hPrc.getIdEntidad());
					if (!Checks.esNulo(tareaSS)) {
						if (!Checks.esNulo(tareaSS.getTareaExterna())) {
							List<TareaExternaValor> listadoValores = tareaSS.getTareaExterna().getValores();
							if (!Checks.esNulo(listadoValores)) {
								for (TareaExternaValor val : listadoValores) {
									if (valor.equals(val.getNombre())) {
										return new ValorNodoTarea(val.getId(), val.getValor());
									}
								}
							}
						}
					}
				}
			}
			return null;
		}

		@Override
		@Transactional(readOnly = false)
		@BusinessOperation(BO_NMB_SUBASTA_EXISTE_REGISTRO_CIERRE_DEUDA)
		public List<BatchAcuerdoCierreDeuda> findRegistroCierreDeuda(Long idSubasta, Long idBien) {
			Subasta subasta = subastaDao.get(idSubasta);
			return subastaDao.findBatchAcuerdoCierreDeuda(subasta.getAsunto().getId(), subasta.getProcedimiento().getId(), idBien);
		}
		
		@Override
		@Transactional(readOnly = false)
		@BusinessOperation(BO_NMB_SUBASTA_FIND_REGISTRO_CIERRE_DEUDA)
		public BatchAcuerdoCierreDeuda findRegistroCierreDeuda(AcuerdoCierreDeudaDto acuerdo) {
			return subastaDao.findBatchAcuerdoCierreDeuda(acuerdo);
		}

		
		private BatchAcuerdoCierreDeuda getCierreDeudaInstance(Long asuId, Long prcId, Long bienId, Long resultadoValidacion, DDResultadoValidacionCDD motivoValidacion, String origen) {

	
			Auditoria auditoria = Auditoria.getNewInstance();
			BatchAcuerdoCierreDeuda cierreDeuda = new BatchAcuerdoCierreDeuda();
			
			Asunto asu = genericDao.get(Asunto.class, genericDao.createFilter(FilterType.EQUALS, "id", asuId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			cierreDeuda.setAsunto(asu);
			Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			cierreDeuda.setProcedimiento(prc);
			
			if(Checks.esNulo(bienId)) {
				cierreDeuda.setEntidad(DDPropiedadAsunto.PROPIEDAD_BANKIA);
		
			}else{
				Bien bie = genericDao.get(Bien.class, genericDao.createFilter(FilterType.EQUALS, "id", bienId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				cierreDeuda.setBien(bie);				
				cierreDeuda.setEntidad(DDPropiedadAsunto.PROPIEDAD_SAREB);
			}

			cierreDeuda.setFechaAlta(Calendar.getInstance().getTime());
			cierreDeuda.setUsuarioCrear(auditoria.getUsuarioCrear());
			cierreDeuda.setResultadoValidacion(resultadoValidacion);
			cierreDeuda.setOrigenPropuesta(origen);
			if(BatchAcuerdoCierreDeuda.PROPIEDAD_RESULTADO_KO.equals(resultadoValidacion)){
				cierreDeuda.setResultadoValidacionCDD(motivoValidacion);
			}
			return cierreDeuda;
		}
		

		/**
		 * Método que genera un informe de validación por bien o por operación e función si recibe idBien a null o no,
		 * y actualiza o modifica un registro en BatchAcuerdoCierreDeuda.
		 * @param subasta
		 * @param idBien
		 * @return InformeValidacionCDDDto informe
		 */
		@Override
		@Transactional(readOnly = false)
		@BusinessOperation(BO_NMB_SUBASTA_GENERAR_ENVIO_CIERRE_DEUDA)
		public InformeValidacionCDDDto generarEnvioCierreDeuda(Subasta subasta, Long idBien, String origen) {
			
			InformeValidacionCDDDto informe;	
			
			if(Checks.esNulo(idBien)) {
				informe = proxyFactory.proxy(SubastaProcedimientoDelegateApi.class)
						.generarInformeValidacionCDD(subasta.getId(), null);
				
			} else {
				informe = proxyFactory.proxy(SubastaProcedimientoDelegateApi.class)
						.generarInformeValidacionCDD(subasta.getId(), String.valueOf(idBien));
				
			}

			String motivo;
			Long resultado;
			DDResultadoValidacionCDD resultadoValidacion = null;
			if(!informe.getValidacionOK()) { // Si Validacion KO
				motivo = informe.getResultadoValidacion().get(0);
				resultado = BatchAcuerdoCierreDeuda.PROPIEDAD_RESULTADO_KO;
				resultadoValidacion = (DDResultadoValidacionCDD) diccionarioApi.dameValorDiccionarioByCod(DDResultadoValidacionCDD.class, motivo);
			
			} else { // Si validación OK
				resultado =  BatchAcuerdoCierreDeuda.PROPIEDAD_RESULTADO_OK;					
			}
			
			// Buscamos si existe un cierre de deuda para mismo ASU,PRO,BIEN que no se haya enviado.
			AcuerdoCierreDeudaDto filtroDto = new AcuerdoCierreDeudaDto();
			
			filtroDto.setAsunto(subasta.getAsunto());
			filtroDto.setProcedimiento(subasta.getProcedimiento());
			if(!Checks.esNulo(idBien)) {
				Bien bie = genericDao.get(Bien.class, genericDao.createFilter(FilterType.EQUALS, "id", idBien), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				filtroDto.setBien(bie);
			}
			BatchAcuerdoCierreDeuda acuerdoCierreDeuda = findRegistroCierreDeuda(filtroDto);
			// Si no existe, o existe pero ya está OK y enviado
			if(Checks.esNulo(acuerdoCierreDeuda) || 
					(!Checks.esNulo(acuerdoCierreDeuda.getFechaEntrega()) && BatchAcuerdoCierreDeuda.PROPIEDAD_RESULTADO_OK.equals(acuerdoCierreDeuda.getResultadoValidacion()))) {
				BatchAcuerdoCierreDeuda autoCierreDeuda = getCierreDeudaInstance(filtroDto.getAsunto().getId(), filtroDto.getProcedimiento().getId(), idBien, resultado, resultadoValidacion, origen);
				genericDao.save(BatchAcuerdoCierreDeuda.class, autoCierreDeuda);
				//guardaBatchAcuerdoCierre(filtroDto.getAsunto().getId(), filtroDto.getProcedimiento().getId(), filtroDto.getBien().getId(), resultado, resultadoValidacion, origen);

			} else {// Si existe sin enviar modificamos		
				acuerdoCierreDeuda.setResultadoValidacion(resultado);
				acuerdoCierreDeuda.setResultadoValidacionCDD(resultadoValidacion);
				acuerdoCierreDeuda.setFechaAlta(Calendar.getInstance().getTime());
				acuerdoCierreDeuda.setOrigenPropuesta(origen);
				genericDao.save(BatchAcuerdoCierreDeuda.class, acuerdoCierreDeuda);
				//guardaBatchAcuerdoCierreDeuda(acuerdoCierreDeuda);				
			}
			
			return informe;
		}
		
		
		public class ValorNodoTarea {
			private Long idTareaNodoValor;
			private String valor;
			
			public ValorNodoTarea() {
			}
			
			public ValorNodoTarea(Long idTareaNodoValor, String valor) {
				this.idTareaNodoValor = idTareaNodoValor;
				this.valor = valor;
			}
			
			/**
			 * @return the idTareaNodoValor
			 */
			public Long getIdTareaNodoValor() {
				return idTareaNodoValor;
			}
			/**
			 * @param idTareaNodoValor the idTareaNodoValor to set
			 */
			public void setIdTareaNodoValor(Long idTareaNodoValor) {
				this.idTareaNodoValor = idTareaNodoValor;
			}
			/**
			 * @return the valor
			 */
			public String getValor() {
				return valor;
			}
			/**
			 * @param valor the valor to set
			 */
			public void setValor(String valor) {
				this.valor = valor;
			}
			
		}
		
		@Override
                @Transactional(readOnly = false)
		@BusinessOperation(BO_NMB_SUBASTA_OBTEN_PROCEDIMIENTO_BIEN_DERIVADO)
		public Procedimiento getProcedimientoBienByIdPadre(NMBBien nmbBien, Subasta subasta, String tipoProcedimiento) {
			Procedimiento prc = null;
			List<ProcedimientoBien> listProcedimientoBien = (List<ProcedimientoBien>) genericDao.getList(ProcedimientoBien.class, 
                                        genericDao.createFilter(FilterType.EQUALS, "bien.id", nmbBien.getId()), 
					genericDao.createFilter(FilterType.EQUALS, "procedimiento.procedimientoPadre.id", subasta.getProcedimiento().getId()),
					genericDao.createFilter(FilterType.EQUALS, "procedimiento.tipoProcedimiento.codigo", tipoProcedimiento));
			
			if(!Checks.estaVacio(listProcedimientoBien)) {
				prc = listProcedimientoBien.get(0).getProcedimiento();
			}
			return prc;
		}
		
		@Override
        @Transactional(readOnly = false)
		@BusinessOperation(BO_NMB_SUBASTA_ELIMINAR_BATCH_ACUERDO_CIERRE_DEUDA)
		public void eliminarBatchCierreDeudaAsunto(Long idAsunto) {

            //Se recorren todos los registros KO de Acuerdo Cierre Deuda (pivote) que hay en el asunto
            List<BatchAcuerdoCierreDeuda> listBatchCDD = (List<BatchAcuerdoCierreDeuda>) genericDao.getList(BatchAcuerdoCierreDeuda.class, 
            genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto));
			
			for(BatchAcuerdoCierreDeuda baCDD : listBatchCDD) {
				if(BatchAcuerdoCierreDeuda.PROPIEDAD_RESULTADO_KO.equals(baCDD.getResultadoValidacion())){
					subastaDao.eliminarBatchAcuerdoCierreDeuda(baCDD);
				}
				else{
	                //Se recorren todos los registros de NUSE que hay relacionados con pivote
	                List<BatchCDDResultadoNuse> listBatchCDDNuse = (List<BatchCDDResultadoNuse>) genericDao.getList(BatchCDDResultadoNuse.class, 
	                                genericDao.createFilter(FilterType.EQUALS, "batchAcuerdoCierreDeuda.id", baCDD.getId()), 
	                                genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	
	                for(BatchCDDResultadoNuse baCDDNuse : listBatchCDDNuse) {
	                        subastaDao.eliminarBatchCDDResultadoNuse(baCDDNuse);
	                }
				}

            }
		}

		@Override
		@BusinessOperation(BO_NMB_GET_LIST_ERROR_PREVI_CDD_DATA)
		public List<DDResultadoValidacionCDD> getListErrorPreviCDDData() {
			Filter fBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Order orderDescripcion = new Order(OrderType.ASC, "descripcion");
			return (ArrayList<DDResultadoValidacionCDD>) genericDao.getListOrdered(DDResultadoValidacionCDD.class, orderDescripcion, fBorrado);
		}

		@Override
		@BusinessOperation(BO_NMB_GET_LIST_ERROR_POST_CDD_DATA)
		public List<DDResultadoValidacionNuse> getListErrorPostCDDData() {
			Filter fBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Order orderDescripcion = new Order(OrderType.ASC, "descripcion");
			return (ArrayList<DDResultadoValidacionNuse>) genericDao.getListOrdered(DDResultadoValidacionNuse.class, orderDescripcion, fBorrado);
		}
		
		@Override
		@BusinessOperation(BO_NMB_SUBASTA_OBTENER_CONTRATO)
		public Contrato getContratoByNroContrato(String nroContrato){
			return subastaDao.getContratoByNroContrato(nroContrato);
		}
		
		@BusinessOperation(BO_NMB_SUBASTA_OBTENER_RELACION_BIENES_CONTRATOS)
		@Override
		public List<NMBContratoBien> getRelacionesContratosBienes(Long[] idBienes) {
			List<NMBContratoBien> listNMBContratoBien = new ArrayList<NMBContratoBien>();
			
			for(int i=0;i<idBienes.length;i++){
				Filter f1 = genericDao.createFilter(FilterType.EQUALS, "bien.id", idBienes[i]);
				Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
				Filter f3 = genericDao.createFilter(FilterType.EQUALS, "contrato.auditoria.borrado", false);
				listNMBContratoBien.addAll(genericDao.getList(NMBContratoBien.class, f1, f2, f3));
			}	
			return listNMBContratoBien;
		}
		
		@BusinessOperation(BO_OBTENER_SITUACION_CARGA)
		@Override
	    public DDSituacionCarga getSituacionCarga(String codigo){
			DDSituacionCarga situacionCarga=null;
			try{
				situacionCarga=genericDao.get(DDSituacionCarga.class, genericDao
					.createFilter(FilterType.EQUALS, "codigo",codigo));
			}catch(Exception e){
				logger.error(e);
			}
			return situacionCarga;
		}
		
		@BusinessOperation(BO_OBTENER_SITUACION_CARGA_ECONOMICA)
		@Override
	    public DDSituacionCarga getSituacionCargaEconomica(String codigo){
	    	DDSituacionCarga situacionCargaEconomica=null;
	    	try{
	    		situacionCargaEconomica = genericDao.get(DDSituacionCarga.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo",codigo));
	    	}catch(Exception e){
	    		logger.error(e);
	    	}
	    	return situacionCargaEconomica;
	    }
	    
		@BusinessOperation(BO_OBTENER_TIPO_CARGA)
		@Override
	    public DDTipoCarga getTipoCarga(String tipoCarga){
	    	DDTipoCarga tipoCargaRes=null;
	    	try{
	    		tipoCargaRes = genericDao.get(DDTipoCarga.class, genericDao
						.createFilter(FilterType.EQUALS, "codigo",tipoCarga));
	    	}catch(Exception e){
	    		logger.error(e);
	    	}
	    	return tipoCargaRes;
	    }
		
		
		/**
	     * upload.
	     * @param uploadForm upload
	     * @return String
	     */
		@Override
	    @BusinessOperation(BO_SUBIR_PLANTILLA_INSTRUCCIONES)
	    @Transactional(readOnly = false)
	    public String upload(WebFileItem uploadForm) {

			try {
				if (uploadForm != null) {

					ExcelFileBean efb = new ExcelFileBean();
					
					FileItem fileItem = uploadForm.getFileItem();
					efb.setFileItem(fileItem);

					//Comprobar tipo de fichero
					if (!masivasUtils.tipoFicheroCorrecto(efb.getFileItem().getContentType())){
						String mensajeError = masivasUtils.obtenerMensajeErrorTipoIncorrecto();
						logger.error(mensajeError);
						throw new BusinessOperationException(mensajeError);
					}
					
					//Comprobaciones sintácticas
					HojaExcel exc = masivasUtils.obtenerExcel(fileItem);
					
					SubastaInstMasivasValidacionDto dto = masivasUtils.validarFormatoFichero(exc);
					if (dto.getFicheroTieneErrores()) {
						String mensajeError = masivasUtils.transformarListaAString(dto.getListaErrores());
						logger.error(mensajeError);
						throw new BusinessOperationException(mensajeError);
					}
					
					//Recuperar los valores de cada uno de los lotes en una lista de Dtos para hacer las validaciones y la operación
					exc.setFile(fileItem.getFile());
					exc.setRuta(fileItem.getFile().getAbsolutePath());
					List<SubastaInstMasivasLoteDto> listaLotes = masivasUtils.recuperarLotes(exc);

					//Comprobaciones de negocio (hay que recibir el id de subasta)
					Long idSubasta = Long.parseLong(uploadForm.getParameter("idSubasta"));
					List<String> listaErroresNegocio = masivasUtils.validacionesNegocio(idSubasta, listaLotes);
					if (listaErroresNegocio.size() > 0) {
						String mensajeError = masivasUtils.transformarListaAString(listaErroresNegocio);
						logger.error(mensajeError);
						throw new BusinessOperationException(mensajeError);
					}
					
					//Recorrer filas y lanzar función de negocio para cada fila (guardarInstruccionesLoteSubasta)
					for (SubastaInstMasivasLoteDto lote : listaLotes) {
						GuardarInstruccionesDto dtoLoteSubasta = masivasUtils.obtenerDtoGuardaInstruccionesLoteSubasta(lote);
						guardaInstruccionesLoteSubasta(dtoLoteSubasta);
					}
				}
			}catch (Exception e) {
				return e.getMessage();
			}
			return "ok";
	    }

}
