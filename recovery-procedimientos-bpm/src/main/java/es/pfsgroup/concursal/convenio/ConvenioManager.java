package es.pfsgroup.concursal.convenio;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.concursal.convenio.dao.ConvenioCreditoDao;
import es.pfsgroup.concursal.convenio.dao.ConvenioDao;
import es.pfsgroup.concursal.convenio.dao.DDEstadoConvenioDao;
import es.pfsgroup.concursal.convenio.dao.DDInicioConvenioDao;
import es.pfsgroup.concursal.convenio.dao.DDPosturaConvenioDao;
import es.pfsgroup.concursal.convenio.dao.DDSiNoDao;
import es.pfsgroup.concursal.convenio.dao.DDTipoConvenioDao;
import es.pfsgroup.concursal.convenio.dto.DtoAgregarConvenio;
import es.pfsgroup.concursal.convenio.dto.DtoConvenio;
import es.pfsgroup.concursal.convenio.dto.DtoConvenioCreditos;
import es.pfsgroup.concursal.convenio.dto.DtoEditarConvenioCredito;
import es.pfsgroup.concursal.convenio.model.Convenio;
import es.pfsgroup.concursal.convenio.model.ConvenioCredito;
import es.pfsgroup.concursal.convenio.model.DDEstadoConvenio;
import es.pfsgroup.concursal.convenio.model.DDInicioConvenio;
import es.pfsgroup.concursal.convenio.model.DDPosturaConvenio;
import es.pfsgroup.concursal.convenio.model.DDTipoAdhesion;
import es.pfsgroup.concursal.convenio.model.DDTipoAlternativa;
import es.pfsgroup.concursal.convenio.model.DDTipoConvenio;
import es.pfsgroup.concursal.credito.dao.CreditoDao;
import es.pfsgroup.concursal.credito.model.Credito;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.integration.Guid;

@Service("convenioManager")
public class ConvenioManager {

	@Autowired
	Executor executor;
	
	@Autowired
	private ConvenioDao convenioDao;

	@Autowired
	private CreditoDao creditoDao;	
	
	@Autowired
	private ConvenioCreditoDao convenioCreditoDao;	

	@Autowired
	private DDSiNoDao siNoDao;
	
	@Autowired
	private DDEstadoConvenioDao estadoConvenioDao;
	
	@Autowired
	private DDPosturaConvenioDao posturaConvenioDao;

	@Autowired
	private DDInicioConvenioDao inicioConvenioDao;
	
	@Autowired
	private DDTipoConvenioDao tipoConvenioDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
    @BusinessOperation("convenioManager.borrarConvenio")
    @Transactional(readOnly = false)
    public void borrarConvenio(Long idConvenio) {
    	convenioDao.deleteById(idConvenio);
    }

	@BusinessOperation("convenioManager.dameConvenioCredito")
	public ConvenioCredito dameConvenioCredito (long idConvenioCredito){
		return convenioCreditoDao.get(idConvenioCredito);
	}

	@BusinessOperation("convenioManager.dameConvenio")
	public Convenio dameConvenio (long idConvenio){
		return convenioDao.get(idConvenio);
	}

	@BusinessOperation("convenioManager.adhesionConvenio")
	public List<DDSiNo> adhesionConvenio(){
		return siNoDao.getList();
	}
	
	@BusinessOperation("convenioManager.tipoAdhesionConvenio")
	public List<DDTipoAdhesion> tipoAdhesionConvenio(){
		return genericDao.getList(DDTipoAdhesion.class);
	}
	
	@BusinessOperation("convenioManager.tipoAlternativaConvenio")
	public List<DDTipoAlternativa> tipoAlternativaConvenio(){
		return genericDao.getList(DDTipoAlternativa.class);
	}
	
	@BusinessOperation("convenioManager.estadosConvenio")
	public List<DDEstadoConvenio> estadosConvenio(){
		return estadoConvenioDao.getList();
	}
	
	@BusinessOperation("convenioManager.posturasConvenio")
	public List<DDPosturaConvenio> posturasConvenio(){
		return posturaConvenioDao.getList();
	}

	@BusinessOperation("convenioManager.iniciosConvenio")
	public List<DDInicioConvenio> iniciosConvenio(){
		return inicioConvenioDao.getList();
	}

	@BusinessOperation("convenioManager.tiposConvenio")
	public List<DDTipoConvenio> tiposConvenio(){
		return tipoConvenioDao.getList();
	}

	/**
	 * Devuelve el listado de convenios en base al procedimiento recivido
	 * busca en el procedimeinto con id mas bajo y de igual numero de auto.
	 * @param idProcedimiento
	 * @return lista de convenios.
	 *  
	 * */
	@BusinessOperation("convenioManager.listaConveniosPorProcedimiento")
	public List<Convenio> listaConveniosPorProcedimiento(Long idProcedimiento){
		List<Convenio> convenios = new ArrayList<Convenio>();
		Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,idProcedimiento);
		String numeroAuto = proc.getCodigoProcedimientoEnJuzgado();
		Long idAsunto = proc.getAsunto().getId();
		Long idProceidmientoMin = null;
		// buscamos el id de procedimeinto mas bajo para el numero de auto tratado
		Asunto asu = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto);
		for (Procedimiento p : asu.getProcedimientos()) {
			if ((p.getCodigoProcedimientoEnJuzgado()!=null)&&(p.getCodigoProcedimientoEnJuzgado().equals(numeroAuto)))
				if ((idProceidmientoMin==null)||(p.getId()<idProceidmientoMin))
					idProceidmientoMin=p.getId();
		}

		if (idProceidmientoMin != null ){
			convenios.addAll(convenioDao.findByProcedimiento(idProceidmientoMin));
		}

		return convenios;
	}
	
	
	
	/**
	 * Devuelve un listado de convenios pertenecientes al asunto 
	 * correspondiente al procedimiento recivido.
	 * 
	 * @param idAsunto
	 * @return lista de convenios.
	 *  
	 * */
	@BusinessOperation("convenioManager.listaConveniosPorAsunto")
	public List<Convenio> listaConveniosPorAsunto(Long idProcedimiento){
		List<Convenio> convenios = new ArrayList<Convenio>();
		Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,idProcedimiento);
		Asunto asunto = proc.getAsunto();
		for (Procedimiento prc : asunto.getProcedimientos()) {
			convenios.addAll(convenioDao.findByProcedimiento(prc.getId()));
		}	
		return convenios;
	}	
	
	/**
	 * Devuelve el listado de creditos definidos para una convenio dado,
	 * 
	 * @param idConvenio
	 * @return lista de creditos para el convenio recivido.
	 *  
	 * */
	@BusinessOperation("convenioManager.listadoConvenioCreditos")
	public List<DtoConvenioCreditos> listadoConvenioCreditos(Long idConvenio) {
		ArrayList<DtoConvenioCreditos> convenioCreditos = new ArrayList<DtoConvenioCreditos>();
		ArrayList<ConvenioCredito> listaCreditosAmostrar = new ArrayList<ConvenioCredito>();
		List<ConvenioCredito> listaCreditos = convenioDao.get(idConvenio).getConvenioCreditos();
		
		// recorrer lista para crear una lista con los creditosConvenios que tienen al menos un valor difinitivo
		for (ConvenioCredito cc : listaCreditos) {
			if (cc.getCredito().getPrincipalDefinitivo()!=null || cc.getCredito().getTipoDefinitivo()!=null)
				listaCreditosAmostrar.add(cc);
		}
		//--------------------------------------------------------------------------------------
		
		if (listaCreditosAmostrar != null) { // solo habra una iteraci�n = un elemento en lista con varios creditos 
			DtoConvenioCreditos convenioCredito = new DtoConvenioCreditos();
			convenioCredito.setConvenio(convenioDao.get(idConvenio));
			convenioCredito.setConvenioCreditos(listaCreditosAmostrar);
			convenioCreditos.add(convenioCredito);
		}
		return convenioCreditos;
	}
	
	/**  
	 * Devuelve el listado de convenios definidos para un asunto,
	 * La b�squeda se basa en el n�mero de auto y se considera �nicamente
	 * el primer procedimiento "Fase comun" encontrado para 
	 * cada n�mero de auto
	 * 
	 * @param idAsunto
	 * @return lista de creditos para el convenio recivido.
	 * 
	 * */
	
	@BusinessOperation("convenioManager.listadoConvenios")
	public List<DtoConvenio> listadoConvenios(Long idAsunto) {
		ArrayList<DtoConvenio> convenios = new ArrayList<DtoConvenio>();
		List<String> listaNumerosAuto = new ArrayList<String>();
		Asunto asu = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto);
		
		
		/* construir lista de numeros de auto */
		for (Procedimiento p : asu.getProcedimientos()) {
			if ((p.getCodigoProcedimientoEnJuzgado()!=null)&&
			((listaNumerosAuto==null) || (!listaNumerosAuto.contains(p.getCodigoProcedimientoEnJuzgado()))))
				if (!listaNumerosAuto.contains(p.getCodigoProcedimientoEnJuzgado())) listaNumerosAuto.add(p.getCodigoProcedimientoEnJuzgado());
		}
		/*----------------------------------*/
		
		if (listaNumerosAuto!=null) { // para cada n�mero auto
			Long idProceidmientoMin;			
			for(String numeroAuto : listaNumerosAuto){
				idProceidmientoMin = null;
				// buscamos el id de procedimeinto mas bajo para el numero de auto tratado
				for (Procedimiento p : asu.getProcedimientos()) {
					if ((p.getCodigoProcedimientoEnJuzgado()!=null)&&(p.getCodigoProcedimientoEnJuzgado().equals(numeroAuto)))
						if ((idProceidmientoMin==null)||(p.getId()<idProceidmientoMin))
							idProceidmientoMin=p.getId();
				}
				if(idProceidmientoMin!=null){
					Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,idProceidmientoMin);
					DtoConvenio convenio = new DtoConvenio();
					convenio.setNumeroAuto(numeroAuto);
					convenio.setIdProcedimientoGenerador(idProceidmientoMin);
					convenio.setConvenios(convenioDao.findByNumAuto(proc.getCodigoProcedimientoEnJuzgado()));
					convenios.add(convenio);
				}
			}
		}
		return convenios;
	}
	
	@BusinessOperation("convenioManager.agregarConvenio")
	@Transactional(readOnly = false)
	public void agregarConvenio(DtoAgregarConvenio dto){
		Convenio convenio = new Convenio();
		Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,dto.getIdProcedimiento());
		
		convenio.setProcedimiento(proc);
		
		if (dto.getEstado()!=null)convenio.setEstadoConvenio(estadoConvenioDao.get(dto.getEstado()));
		if (dto.getPostura()!=null)convenio.setPosturaConvenio(posturaConvenioDao.get(dto.getPostura()));
		if (dto.getInicio()!=null)convenio.setInicioConvenio(inicioConvenioDao.get(dto.getInicio()));
		if (dto.getTipo()!=null)convenio.setTipoConvenio(tipoConvenioDao.get(dto.getTipo()));
		if (dto.getAdherirse()!=null)convenio.setAdherirse(siNoDao.get(dto.getAdherirse()));
		
		if (!Checks.esNulo(dto.getAlternativa())) {
			DDTipoAlternativa tipoAlternativa = (DDTipoAlternativa) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionario(DDTipoAlternativa.class, dto.getAlternativa());
			convenio.setTipoAlternativa(tipoAlternativa);
		}
		
		if (!Checks.esNulo(dto.getTipoAdhesion())) {
			DDTipoAdhesion tipoAdhesion= (DDTipoAdhesion) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionario(DDTipoAdhesion.class, dto.getTipoAdhesion());
			convenio.setTipoAdhesion(tipoAdhesion);
		}
		
		convenio.setNumProponentes(dto.getNumeroProponentes());
		convenio.setTotalMasa(dto.getTotalMasa());
		convenio.setTotalMasaOrd(dto.getTotalMasaOrd());
		convenio.setPorcentaje(dto.getPorcentaje());
		convenio.setPorcentajeOrd(dto.getPorcentajeOrd());
		
		try {
			convenio.setFecha(DateFormat.toDate(dto.getFecha()));
		} catch (ParseException e) {
			throw new BusinessOperationException(dto.getFecha().concat(": no es un formato de fecha valido"),e);
		}
		convenio.setDescripcion(dto.getDescripcion());
		convenio.setDescripcionAdhesiones(dto.getDescripcionAdhesiones());
		convenio.setDescripcionAnticipado(dto.getDescripcionAnticipado());
		convenio.setDescripcionTerceros(dto.getDescripcionTerceros());
		convenio.setDescripcionConvenio(dto.getDescripcionConvenio());
		
		convenioDao.save(convenio);
		
		// agregar los creditos con categoria definitiva en caso de que el convenio sea ordinario
		//if(convenio.getTipoConvenio().getCodigo().equals("2")){
			List<ConvenioCredito> convenioCreditos = new ArrayList<ConvenioCredito>();
			Procedimiento p = convenio.getProcedimiento();
			for (ExpedienteContrato ec : p.getExpedienteContratos()) {
				List<Credito> listaCreditosDifinitivos = new ArrayList<Credito>();
				listaCreditosDifinitivos = creditoDao.findByContratoProcedimientoDefinitivos(ec.getId(),p.getId());
				for (Credito creditoInsertar : listaCreditosDifinitivos) {
					ConvenioCredito convenioCredito = new ConvenioCredito();
					convenioCredito.setConvenio(convenio);
					convenioCredito.setCredito(creditoInsertar);
					convenioCreditoDao.save(convenioCredito);
					
					convenioCreditos.add(convenioCredito);
				}
			}
			
			convenio.setConvenioCreditos(convenioCreditos);
		//}
		// ---------------------------------------------------------------------------------------
	}
	
	@BusinessOperation("convenioManager.editarConvenioCredito")
	@Transactional(readOnly = false)
	public void editarConvenioCredito(DtoEditarConvenioCredito dto){
		ConvenioCredito convenioCredito = convenioCreditoDao.get(dto.getIdConvenioCredito());
		convenioCredito.setGuid(dto.getGuid());
		convenioCredito.setQuita(dto.getQuita());
		convenioCredito.setEspera(dto.getEspera());
		convenioCredito.setComentario(dto.getComentario());
		convenioCredito.setCarencia(dto.getCarencia());		
		convenioCreditoDao.save(convenioCredito);
	}
	
	@BusinessOperation("convenioManager.editarConvenio")
	@Transactional(readOnly = false)
	public void editarConvenio(DtoAgregarConvenio dto){
		Convenio convenio = convenioDao.get(dto.getIdConvenio());
		convenio.setGuid(dto.getGuid());
		Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,dto.getIdProcedimiento());
		
		convenio.setProcedimiento(proc);
		
		try {
			convenio.setFecha(DateFormat.toDate(dto.getFecha()));
		} catch (ParseException e) {
			throw new BusinessOperationException(dto.getFecha().concat(": no es un formato de fecha valido"),e);
		}
		convenio.setNumProponentes(dto.getNumeroProponentes());
		convenio.setTotalMasa(dto.getTotalMasa());
		convenio.setTotalMasaOrd(dto.getTotalMasaOrd());
		convenio.setPorcentaje(dto.getPorcentaje());
		convenio.setPorcentajeOrd(dto.getPorcentajeOrd());
		convenio.setDescripcion(dto.getDescripcion());
		convenio.setDescripcionAdhesiones(dto.getDescripcionAdhesiones());
		convenio.setDescripcionAnticipado(dto.getDescripcionAnticipado());
		convenio.setDescripcionTerceros(dto.getDescripcionTerceros());
		convenio.setDescripcionConvenio(dto.getDescripcionConvenio());
		
		if (dto.getEstado()!=null) convenio.setEstadoConvenio(estadoConvenioDao.get(dto.getEstado()));
		else convenio.setEstadoConvenio(null);
		if (dto.getPostura()!=null) convenio.setPosturaConvenio(posturaConvenioDao.get(dto.getPostura()));
		else convenio.setPosturaConvenio(null);
		if (dto.getInicio()!=null) convenio.setInicioConvenio(inicioConvenioDao.get(dto.getInicio()));
		else convenio.setInicioConvenio(null);
		if (dto.getTipo()!=null) convenio.setTipoConvenio(tipoConvenioDao.get(dto.getTipo()));
		else convenio.setTipoConvenio(null);
		if (dto.getAdherirse()!=null) convenio.setAdherirse(siNoDao.get(dto.getAdherirse()));
		else convenio.setAdherirse(null);
		
		if (!Checks.esNulo(dto.getAlternativa())) {
			DDTipoAlternativa tipoAlternativa = (DDTipoAlternativa) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionario(DDTipoAlternativa.class, dto.getAlternativa());
			convenio.setTipoAlternativa(tipoAlternativa);
		}
		
		if (!Checks.esNulo(dto.getTipoAdhesion())) {
			DDTipoAdhesion tipoAdhesion= (DDTipoAdhesion) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionario(DDTipoAdhesion.class, dto.getTipoAdhesion());
			convenio.setTipoAdhesion(tipoAdhesion);
		}
		
		convenioDao.save(convenio);
	}
	
	public void guardarConvenio(DtoAgregarConvenio convenioDto, List<DtoEditarConvenioCredito> convenioCreditosDto) 
	{	
		Convenio convenio = new Convenio();
		Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, convenioDto.getIdProcedimiento());
		
		convenio.setProcedimiento(proc);
		
		if (convenioDto.getEstado()!=null) {
			convenio.setEstadoConvenio(estadoConvenioDao.get(convenioDto.getEstado()));
		}
		
		if (convenioDto.getPostura()!=null) {
			convenio.setPosturaConvenio(posturaConvenioDao.get(convenioDto.getPostura()));
		}
		
		if (convenioDto.getInicio()!=null) {
			convenio.setInicioConvenio(inicioConvenioDao.get(convenioDto.getInicio()));
		}
		
		if (convenioDto.getTipo()!=null) {
			convenio.setTipoConvenio(tipoConvenioDao.get(convenioDto.getTipo()));
		}
		
		if (convenioDto.getAdherirse()!=null) {
			convenio.setAdherirse(siNoDao.get(convenioDto.getAdherirse()));
		}
		
		if (!Checks.esNulo(convenioDto.getAlternativa())) {
			DDTipoAlternativa tipoAlternativa = (DDTipoAlternativa) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionario(DDTipoAlternativa.class, convenioDto.getAlternativa());
			convenio.setTipoAlternativa(tipoAlternativa);
		}
		
		if (!Checks.esNulo(convenioDto.getTipoAdhesion())) {
			DDTipoAdhesion tipoAdhesion= (DDTipoAdhesion) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionario(DDTipoAdhesion.class, convenioDto.getTipoAdhesion());
			convenio.setTipoAdhesion(tipoAdhesion);
		}
		
		convenio.setNumProponentes(convenioDto.getNumeroProponentes());
		convenio.setTotalMasa(convenioDto.getTotalMasa());
		convenio.setTotalMasaOrd(convenioDto.getTotalMasaOrd());
		convenio.setPorcentaje(convenioDto.getPorcentaje());
		convenio.setPorcentajeOrd(convenioDto.getPorcentajeOrd());
		
		try {
			convenio.setFecha(DateFormat.toDate(convenioDto.getFecha()));
		} 
		catch (ParseException e) {
			throw new BusinessOperationException(convenioDto.getFecha().concat(": no es un formato de fecha valido"),e);
		}
		
		convenio.setDescripcion(convenioDto.getDescripcion());
		convenio.setDescripcionAdhesiones(convenioDto.getDescripcionAdhesiones());
		convenio.setDescripcionAnticipado(convenioDto.getDescripcionAnticipado());
		convenio.setDescripcionTerceros(convenioDto.getDescripcionTerceros());
		convenio.setDescripcionConvenio(convenioDto.getDescripcionConvenio());
		
		if(convenioCreditosDto != null) {
			for(DtoEditarConvenioCredito convenioCreditoDto : convenioCreditosDto) {
				
				ConvenioCredito convenioCredito = new ConvenioCredito();
				convenioCredito.setConvenio(convenio);
				convenioCredito.setCredito(convenioCreditoDto.getCredito());
				convenioCredito.setGuid(convenioCreditoDto.getGuid());
				convenioCredito.setQuita(convenioCreditoDto.getQuita());
				convenioCredito.setEspera(convenioCreditoDto.getEspera());
				convenioCredito.setComentario(convenioCreditoDto.getComentario());
				convenioCredito.setCarencia(convenioCreditoDto.getCarencia());		
				
				convenioCreditoDao.save(convenioCredito);
			}
		}
		
		convenioDao.save(convenio);
	}

	
	@BusinessOperation("convenioManager.dameEstadoPorDefecto")
	public long dameEstadoPorDefecto(){
		List<DDEstadoConvenio> listaEstados = estadoConvenioDao.getList();
		if (listaEstados != null) 
			for (DDEstadoConvenio ec : listaEstados) {
				if (ec.getCodigo().equals("1")) 
					return ec.getId();
			}
		// c�digo devuelto por defecto
		return 2;
	}
	
	@BusinessOperation("convenioManager.dameFechaPorDefecto")
	public Date dameFechaPorDefecto(){
		Date fechaSistema = new Date();
		return fechaSistema;
	}
	
	public boolean existeNumeroAutoEnProcedimiento(Long idProcedimiento){
		System.out.println("existeNumeroAutoEnProcedimiento");
		boolean resultado = false;
		System.out.println(idProcedimiento);
		Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,idProcedimiento);
		String numeroAuto = proc.getCodigoProcedimientoEnJuzgado();
		System.out.println("Numero auto" +numeroAuto);
		if(numeroAuto != null && numeroAuto.contains("/"))
			resultado = true;
		return resultado;
	}
	
	public Convenio getConvenioByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		Convenio convenio = genericDao.get(Convenio.class, filtro);
		return convenio;
	}

	public ConvenioCredito getConvenioCreditoByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		ConvenioCredito convenioCredito = genericDao.get(ConvenioCredito.class, filtro);
		return convenioCredito;
	}

	public Convenio prepareGuid(Convenio convenio) {
		if (Checks.esNulo(convenio.getGuid())) {
			
			String guid = Guid.getNewInstance().toString();
			while(getConvenioByGuid(guid) != null) {
				guid = Guid.getNewInstance().toString();
			}
			
			convenio.setGuid(guid);
			convenioDao.saveOrUpdate(convenio);
		}
	
		if (convenio.getConvenioCreditos() != null) {
			for (ConvenioCredito convenioCreditos : convenio.getConvenioCreditos()) {
				prepareGuid(convenioCreditos);
			}
		}
		
		return convenio;
	}

	private ConvenioCredito prepareGuid(ConvenioCredito convenioCredito) {
		if (Checks.esNulo(convenioCredito.getGuid())) {
			
			String guid = Guid.getNewInstance().toString();
			while(getConvenioCreditoByGuid(guid) != null) {
				guid = Guid.getNewInstance().toString();
			}
			
			convenioCredito.setGuid(guid);
			genericDao.save(ConvenioCredito.class, convenioCredito);
		}
		
		return convenioCredito;
	}

}
