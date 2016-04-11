package es.pfsgroup.plugin.recovery.liquidaciones;

import java.sql.Date;
import java.text.ParseException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.dao.AsuntoDao;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cobropago.model.DDEstadoCobroPago;
import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.LIQCobroPagoDao;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoCobroPago;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoCobroPagoEntregas;
import es.pfsgroup.plugin.recovery.liquidaciones.model.DDModalidadCobro;
import es.pfsgroup.plugin.recovery.liquidaciones.model.DDOrigenCobro;
import es.pfsgroup.plugin.recovery.liquidaciones.model.LIQCobroPago;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableConceptoEntrega;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableTipoEntrega;

@Component("plugin.liquidaciones.cobroPagoEntregasManager")
public class LIQCobroPagoEntregasManager {
	
	@Autowired
	Executor executor;
	
	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	LIQCobroPagoDao cobroPagoDao;
	
	@Autowired
	AsuntoDao asunto;
	
	@Autowired
	ProcedimientoDao procedimiento;
	
	
	
	 public List<LIQCobroPago> getListbyAsuntoId(Long id) {
	    	List<LIQCobroPago> lista = cobroPagoDao.getByIdAsunto(id); 
	        return lista;
	 }
	 
	 public LIQCobroPago getInstance(Long idAsunto) {
			EventFactory.onMethodStart(this.getClass());
			
			Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto);
			LIQCobroPago cobroPago = new LIQCobroPago();
			cobroPago.setAsunto(asunto);
			cobroPago.setAuditoria(Auditoria.getNewInstance());
			
			EventFactory.onMethodStop(this.getClass());
			return cobroPago;
	 }
	 
	 public LIQCobroPago get(Long id) {
			EventFactory.onMethodStart(this.getClass());
			return cobroPagoDao.get(id);
		}
	 
	 @Transactional(readOnly = false)
	 public void createOrUpdate(LIQDtoCobroPagoEntregas dto) {
		 
		 
		 	Assertions.assertNotNull(dto,
					"plugin.liquidaciones.liqcobropagomanager.dto.null");
//			Assertions.assertNotNull(dto.getProcedimiento(),
//					"Debe seleccionar una actuaci�n");
			
			Long idAsunto= dto.getIdAsunto();
			String subTipo= dto.getSubtipo();//Codigo EC
			String estado= dto.getEstado();//Float 03
			String tipoEntrega= dto.getTipoEntrega();//Codigo CAN
			String conceptoEntrega= dto.getConceptoEntrega();//Concepto Entrega
			String fecha= dto.getFechaEntrega();
			String fechaValor= dto.getFechaValor();
			Float capital= dto.getCapital();
			Float capitalNoVencido= dto.getCapitalNoVencido();
			Float intereses= dto.getInteresesOrdinarios();
			Float interesesDemora= dto.getInteresesMoratorios();
			Float impuestos= dto.getImpuestos();
			Float gastosAbogado= dto.getGastosAbogado();
			Float gastosProcurador= dto.getGastosProcurador();
			Float gastosOtros= dto.getOtrosGastos();
			Float gastos= dto.getGastos();
			
			LIQCobroPago cobroPago= null;
			
			if(dto.getId() != null){
				cobroPago= get(dto.getId());
			}
			else{
				cobroPago= getInstance(idAsunto);
			}

			
			if(subTipo != null){
				DDSubtipoCobroPago ddsubTipo = genericDao.get(DDSubtipoCobroPago.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),genericDao.createFilter(FilterType.EQUALS, "codigo", subTipo));
				Assertions.assertNotNull(ddsubTipo, "SubTipo no valido");
				cobroPago.setSubTipo(ddsubTipo);
			}
			
			if(estado != null){
				DDEstadoCobroPago ddEstado = genericDao.get(DDEstadoCobroPago.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),genericDao.createFilter(FilterType.EQUALS, "codigo", estado));
				Assertions.assertNotNull(ddEstado, "Estado no valido");
				cobroPago.setEstado(ddEstado);
			}
			
			if(tipoEntrega != null){
				DDAdjContableTipoEntrega ddTipoEntrega = genericDao.get(DDAdjContableTipoEntrega.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),genericDao.createFilter(FilterType.EQUALS, "codigo", tipoEntrega));
				Assertions.assertNotNull(ddTipoEntrega, "Tipo no valido");
				cobroPago.setTipoEntrega(ddTipoEntrega);
			}
			
			if(conceptoEntrega != null){
				DDAdjContableConceptoEntrega ddConceptoEntrega = genericDao.get(DDAdjContableConceptoEntrega.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false),genericDao.createFilter(FilterType.EQUALS, "codigo", conceptoEntrega));
				Assertions.assertNotNull(ddConceptoEntrega, "Concepto no valido");
				cobroPago.setConceptoEntrega(ddConceptoEntrega);
			}
			
			if(fecha != null && fecha != ""){
				try {
					Date sqlFE = new java.sql.Date(DateFormat.toDate(dto.getFechaEntrega()).getTime());
					cobroPago.setFecha(sqlFE);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				Assertions.assertNotNull(fecha, "Fecha no valida");
			}
			
			if(fechaValor != null && fechaValor != ""){
				try {
					Date sqlFV = new java.sql.Date(DateFormat.toDate(dto.getFechaValor()).getTime());
					cobroPago.setFechaValor((sqlFV));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				Assertions.assertNotNull(fechaValor, "Fecha no valida");

			}
			
			cobroPago.setCapital(capital);
			cobroPago.setCapitalNoVencido(capitalNoVencido);
			cobroPago.setInteresesOrdinarios(intereses);
			cobroPago.setInteresesMoratorios(interesesDemora);
			cobroPago.setImpuestos(impuestos);
			cobroPago.setGastosAbogado(gastosAbogado);
			cobroPago.setGastosProcurador(gastosProcurador);
			cobroPago.setGastos(gastos);
			cobroPago.setGastosOtros(gastosOtros);
			cobroPago.setImporte(dto.getImportePago());
			
			if(dto.getProcedimiento() != null){
				Procedimiento proc= procedimiento.get(dto.getProcedimiento());
				cobroPago.setProcedimiento(proc);
			}
			
			if (!Checks.esNulo(cobroPago.getSubTipo())) {
				if (Checks.esNulo(dto.getContrato())){
					throw new BusinessOperationException("plugin.liquidaciones.liqcobropagomanager.idcontrato.null");
				}
				Contrato cnt = (Contrato) executor.execute(
						PrimariaBusinessOperation.BO_CNT_MGR_GET, dto
								.getContrato());
				Assertions.assertNotNull(cnt, "plugin.liquidaciones.error.contrato.null");
				cobroPago.setContrato(cnt);
			}
			
			cobroPagoDao.saveOrUpdate(cobroPago);
			
			
		 
	}

}
