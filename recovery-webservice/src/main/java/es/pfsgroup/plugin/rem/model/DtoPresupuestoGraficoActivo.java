package es.pfsgroup.plugin.rem.model;





/**
 * Dto para los incrementos de presupuesto del activo
 * @author Benjamín Guerrero
 *
 */
public class DtoPresupuestoGraficoActivo {

		private Long id;	
		private String ejercicio;
		private Double presupuesto;
		private Double gastado;
		private Double dispuesto;
		private Double disponible;
		private Double gastadoPorcentaje;
		private Double dispuestoPorcentaje;
		private Double disponiblePorcentaje;
		
		public Long getId() {
			return id;
		}
		public void setId(Long id) {
			this.id = id;
		}
		public Double getPresupuesto() {
			return presupuesto;
		}
		public void setPresupuesto(Double presupuesto) {
			this.presupuesto = presupuesto;
		}
		public Double getGastado() {
			return gastado;
		}
		public void setGastado(Double gastado) {
			this.gastado = gastado;
		}
		public Double getDispuesto() {
			return dispuesto;
		}
		public void setDispuesto(Double dispuesto) {
			this.dispuesto = dispuesto;
		}
		public Double getDisponible() {
			return disponible;
		}
		public void setDisponible(Double disponible) {
			this.disponible = disponible;
		}
		public String getEjercicio() {
			return ejercicio;
		}
		public void setEjercicio(String ejercicio) {
			this.ejercicio = ejercicio;
		}
		public Double getGastadoPorcentaje() {
			return gastadoPorcentaje;
		}
		public void setGastadoPorcentaje(Double gastadoPorcentaje) {
			this.gastadoPorcentaje = gastadoPorcentaje;
		}
		public Double getDispuestoPorcentaje() {
			return dispuestoPorcentaje;
		}
		public void setDispuestoPorcentaje(Double dispuestoPorcentaje) {
			this.dispuestoPorcentaje = dispuestoPorcentaje;
		}
		public Double getDisponiblePorcentaje() {
			return disponiblePorcentaje;
		}
		public void setDisponiblePorcentaje(Double disponiblePorcentaje) {
			this.disponiblePorcentaje = disponiblePorcentaje;
		}

    
}