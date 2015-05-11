package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model;

import java.math.BigDecimal;
import java.util.Date;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.procesosJudiciales.model.DDPostores2;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDtipoSubasta;

public interface NMBSubastaInstruccionesInfo  {

	Long getId();
    
	Bien getBien();
	
	Procedimiento getProcedimiento();
	
	NMBDDtipoSubasta getTipoSubasta();
	
	Date getPrimeraSubasta();
	
	Date getSegundaSubasta();
	
	Date getTerceraSubasta();
	
	Usuario getNotario();
	
	Float getValorSubasta();
	
	Float getTotalDeuda();
	
	BigDecimal getPrincipal();
	
	Float getCargasAnteriores();
	
	Float getPeritacionActual();
	
	Float getTipoSegundaSubasta();
	
	Float getImporteSegundaSubasta();
	
	Float getTipoTerceraSubasta();
	
	Float getImporteTerceraSubasta();
	
	Float getResponsabilidadCapital();
	
	Float getResponsabilidadIntereses();
	
	Float getResponsabilidadDemoras();
	
	Float getResponsabilidadCostas();

	Float getPropuestaCapital();
	
	Float getPropuestaIntereses();
	
	Float getPropuestaDemoras();
	
	Float getPropuestaCostas();
	
	Date getFechaInscripcion();
	
	Date getFechaLlaves();
	
	String getObservacion();
	
	Float getCostasProcurador();
	
	Float getCostasLetrado();
	
	Float getLimiteConPostores();
	
	DDPostores2 getPostores();
}

