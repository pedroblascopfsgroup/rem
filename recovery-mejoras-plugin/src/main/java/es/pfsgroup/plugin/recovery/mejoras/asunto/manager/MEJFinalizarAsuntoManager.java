package es.pfsgroup.plugin.recovery.mejoras.asunto.manager;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.EXTAsuntoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procedimiento.dao.EXTProcedimientoDao;
import es.capgemini.pfs.registro.ModificacionAsuntoListener;
import es.pfsgroup.plugin.recovery.coreextension.api.AsuntoCoreApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;

@Component
public class MEJFinalizarAsuntoManager implements AsuntoCoreApi {

    public static final String MEJ_FINALIZAR_ASUNTO = "plugin.mejoras.finalizarAsunto";
    public static final String MEJ_CANCELAR_ASUNTO = "plugin.mejoras.cancelaAsunto";
    public static final String MEJ_PARALIZAR_ASUNTO = "plugin.mejoras.paralizaAsunto";
    	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private EXTAsuntoDao asuntoDao;

	@Autowired
	private ModificacionAsuntoListener mejModAsuntoREG;
	
	@Autowired
	private EXTAsuntoApi extAsuntoApi;

	@Autowired
	private EXTProcedimientoDao procedimientoDao;
	
	@BusinessOperation(MEJ_FINALIZAR_ASUNTO)
	public void finalizarAsunto(MEJFinalizarAsuntoDto dto) {
		extAsuntoApi.finalizarAsunto(dto);
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.mejoras.asunto.api.MEJFinalizarAsuntoApi#cancelaAsunto(es.capgemini.pfs.asunto.model.Asunto, java.util.Date)
	 */
	@BusinessOperation(MEJ_CANCELAR_ASUNTO)
	public void cancelaAsunto(Asunto asunto, Date fechaCancelacion) {
		DDEstadoAsunto esAsuCancelado = (DDEstadoAsunto)diccionarioApi.dameValorDiccionarioByCod(DDEstadoAsunto.class, DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO);
		DDEstadoProcedimiento esPrcCerrado = (DDEstadoProcedimiento)diccionarioApi.dameValorDiccionarioByCod(DDEstadoProcedimiento.class, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO);
		List<Procedimiento> procedimientos = asunto.getProcedimientos();
		for (Procedimiento procedimiento : procedimientos) {
			if ((!DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO.equals(procedimiento.getEstadoProcedimiento().getCodigo())) &&
				(!DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(procedimiento.getEstadoProcedimiento().getCodigo())))	 {
					procedimiento.setEstadoProcedimiento(esPrcCerrado);
					procedimientoDao.saveOrUpdate(procedimiento);
				}
		}

		if (DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO.equals(asunto.getEstadoAsunto().getCodigo())) { 
			
			Map<String, Object> mapCancelacion = new HashMap<String, Object>();
			mapCancelacion.put(ModificacionAsuntoListener.ID_ASUNTO, asunto.getId());
			mapCancelacion.put("FechaCancelacion", fechaCancelacion);

			mejModAsuntoREG.fireEvent(mapCancelacion);
			
			asunto.setEstadoAsunto(esAsuCancelado);	
			asuntoDao.saveOrUpdate(asunto);
		}
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.mejoras.asunto.api.MEJFinalizarAsuntoApi#paralizaAsunto(es.capgemini.pfs.asunto.model.Asunto, java.util.Date)
	 */
	@BusinessOperation(MEJ_PARALIZAR_ASUNTO)
	public void paralizaAsunto(Asunto asunto, Date fechaParalizacion) {
		extAsuntoApi.paralizaAsunto(asunto,fechaParalizacion);
	}	
	
	// TODO Este método se creó en Lindorff, 
	// revisar y ver si se saca de aquí y del coreextension, de momento llamamos al cancelaAsunto 
	@Override
	public void cancelaAsuntoConMotivo(Asunto asunto, Date fechaCancelacion, String motivo) {
		this.cancelaAsunto(asunto, fechaCancelacion);		
	}
	
}
