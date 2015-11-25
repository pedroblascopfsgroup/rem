package es.pfsgroup.plugin.proyectoBankiaOnline.adjudicacion.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.proyectoBankiaOnline.adjudicacion.api.AdjudicacionApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;

@Service("adjudicacionManager")
public class AdjudicacionManager implements AdjudicacionApi{
	
	@Autowired
	private GenericABMDao genericDao;	
	
	/**
	 * BANKIA
	 * Metodo que devuelve null en caso de todo ir bien, en caso contrario devuelve el mensaje de error
	 * Validaciones PRE
	 */
	@Override
	@BusinessOperation(BO_ADJUDICACION_VALIDACIONES_ADJUDICACION_ENTREGA_TITULO)
	public String validacionesAdjudicacionEntregaTituloPRE(Long idProcedimiento) {
		// Buscamos primero el bien asociado al procedimiento
		ProcedimientoBien prcBien = genericDao.get(ProcedimientoBien.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProcedimiento), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		//Preformato para mensajes de validación en tareas
		String formatoMensajeIn = "<div align=\"justify\" style=\"font-size: 8pt; font-family: Arial; margin-bottom: 10px;\">";
		String formatoMensajeOut = "</div>";
		String mensajeError = "";
		
		if (!Checks.esNulo(prcBien)) 
		{
			Bien bien = prcBien.getBien();
			NMBBien b = genericDao.get(NMBBien.class, genericDao.createFilter(FilterType.EQUALS, "id", bien.getId()));
			
			if (b instanceof NMBBien) {				

				if(Checks.esNulo(((NMBBien) b).getTributacion())){
					mensajeError = mensajeError+"Debe completar el Tipo de impuesto compra de los bienes. ";
				}
				if(Checks.esNulo(((NMBBien) b).getPorcentajeImpuestoCompra())){
					mensajeError = mensajeError+"Debe completar el Porcentaje de impuesto de compra del bien. ";
				}
				if(Checks.esNulo(((NMBBien) b).getImpuestoCompra())){
					mensajeError = mensajeError+"Debe completar el Cod TP impuesto compra del bien.";
				}
			}
		}
		
		if(mensajeError.length() > 1)
			return formatoMensajeIn+mensajeError+formatoMensajeOut;
		else
			return null;
	}
}
