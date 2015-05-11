describe("Suite de testeo del Controlador Asíncrono", function() {

	/*
	 * PRUEBAS BÁSICAS DE INICIALIZACIÓN 
	 */
	describe("Tests básicos de inicialización", function() {

		var controlador;
		
		beforeEach(function(){
			controlador = new es.pfs.plugins.masivo.ControladorAsincrono();
		});
  
		afterEach(function(){
			controlador = null;
		});
  
		it("El controlador asíncrono está definido", function() {
			expect(es.pfs.plugins.masivo.ControladorAsincrono).toBeDefined();
		});
  
		it("El controlador se ha podido instanciar", function(){
			expect(controlador).toBeDefined();
			expect(controlador).not.toBeNull();
		});
	});
	
	/*
	 * TESTS DE LLAMADAS AL AjaxEngine
	 */
	describe("Tests de llamadas al AjaxEngine", function(){
		var controlador;
		var mockAjaxEngine;
		var request = 'no';
		
		var idTipoOperacion;
		var form;
		
		beforeEach(function(){
			Ext.ns('Ext.Ajax');
			mockAjaxEngine = {
					request:function(){request = 'yes';}
			};
			Ext.Ajax.request = function(){request = 'yes';};
			controlador = new es.pfs.plugins.masivo.ControladorAsincrono();
			spyOn(mockAjaxEngine, "request");
			spyOn(Ext.Ajax, "request");
			
			idTipoOperacion = Math.random();
			form = new Ext.FormPanel({
				items:[{
					xtype: 'textfield'
					,name: 'path'
					,value: 'test path'
				}]
			});
		});
		
		afterEach(function(){
			controlador = null;
			mockAjaxEngine = null;
			request = 'no';
			
			idTipoOperacion = null;
			form = null;
		});
		
		it("nuevoProceso() realiza la llamada Ajax", function(){
			controlador.nuevoProceso(idTipoOperacion, form.getForm());
			expect(Ext.Ajax.request).toHaveBeenCalled();
		});
	});
});	