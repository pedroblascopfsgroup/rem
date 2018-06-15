Ext.define('HreRem.view.masivo.MasivoController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.masivo',
    
    
    onClickBotonSubirMasivo: function(btn) {
    	var me = this,
    	form = me.getView().lookupReference("cargamasivaFormRef");
    	
    	var params = form.getValues(false,false,false,true);

    	if(form.isValid()){
            
            form.submit({
                waitMsg: HreRem.i18n('msg.mask.loading'),
                params: params,
                success: function(fp, o) {

                	if(!Ext.isEmpty(o.response.responseText)) {
                		var response = Ext.JSON.decode(o.response.responseText);
                		if(response.success == "false")  {
                			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));  
                			me.getView().lookupReference("listadoCargamasiva").getStore().load();
                		} else {		                			                	
		                    me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		                    me.getView().lookupReference("listadoCargamasiva").getSelectionModel().deselectAll();
                        	me.getView().lookupReference("listadoCargamasiva").getSelectionModel().clearSelections();
		                    me.getView().lookupReference("listadoCargamasiva").getStore().load();
		                    me.getView().lookupReference("listadoCargamasiva").down('#procesarButton').setDisabled(true);
    						me.getView().lookupReference("listadoCargamasiva").down('#downloadButton').setDisabled(true);
                		}
                	}

                }, 
                failure: function(fp, o) {
                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ok"));                	
                }
            })
    	}
    },
    
    onClickBotonValidar: function(btn) {

    	var me = this;
    	var parameters = {};
    	parameters.idProcess = this.getView().down('grid').selection.data.id;
        parameters.idOperation = this.getView().down('grid').selection.data.tipoOperacionId;
    	var url =  $AC.getRemoteUrl('masivo/validar');
    	me.getView().mask(HreRem.i18n('msg.mask.loading'));
		Ext.Ajax.request({
			 method: 'GET',
		     url: url,
		     params: parameters,
		     timeout: 120000,  // 2 min
		     success: function(response, opts) {
		     	 me.getView().unmask();
			     btn.up('grid').getStore().load();
			     btn.up('grid').getSelectionModel().deselectAll();
                 btn.up('grid').getSelectionModel().clearSelections();
                 btn.up('grid').down('#procesarButton').setDisabled(true);
                 btn.up('grid').down('#downloadButton').setDisabled(true);
                 btn.up('grid').down('#downloadButton').setDisabled(true);
			     me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		     },
		     failure: function(response, opts) {
			     	me.getView().unmask();
			     	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		     }
		 });

    },
    
    onClickBotonDescargarPlantilla: function(btn) {
    	
    	var me = this,
		config = {};
		
		config.url= $AC.getRemoteUrl("process/downloadTemplate");
		config.params = {};
		config.params.idTipoOperacion = me.getView().lookupReference("comboTipoOperacionRef").getValue();
		
		me.fireEvent("downloadFile", config);	
    	
    	
    },
    
    onClickDescargarErrores: function(btn) {

    	var me = this,
		config = {};

		config.url= $AC.getRemoteUrl("process/downloadErrors");
		config.params = {};
		config.params.idProcess = this.getView().down('grid').selection.data.id;

		me.fireEvent("downloadFile", config);	
    },
    
    
    onClickDescargarResultados: function(btn) {

    	var me = this,
		config = {};

		config.url= $AC.getRemoteUrl("process/downloadResultados");
		config.params = {};
		config.params.idProcess = this.getView().down('grid').selection.data.id;

		me.fireEvent("downloadFile", config);	
    },
    
    
    onClickBotonProcesar: function(btn,b,c) {

    	var me = this;
    	var parameters = {};
    	parameters.idProcess = this.getView().down('grid').selection.data.id;
        parameters.idOperation = this.getView().down('grid').selection.data.tipoOperacionId;
    	var url =  $AC.getRemoteUrl('masivo/procesarMasivo');
    	me.getView().mask(HreRem.i18n('msg.mask.loading'));
		Ext.Ajax.request({
			 method: 'GET',
		     url: url,
		     params: parameters,
		     timeout: 120000,  // 2 min
		     success: function(response, opts) {
		     	 
		     	 var data = {};
		         try {
		         	data = Ext.decode(response.responseText);
		         } catch (e){ };
		       
		         me.getView().unmask();
		         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		         me.getView().lookupReference("listadoCargamasiva").getStore().load();
		     },
		     failure: function(response, opts) {
		     	
		         Ext.Ajax.request({
		         	 method: 'GET',
				     url:$AC.getRemoteUrl('process/setStateError'),
				     params: parameters,
				     success: function(response, opts) {
				     	me.getView().unmask();
				     	btn.up('grid').getStore().load();
				     	btn.up('grid').getSelectionModel().deselectAll();
                        btn.up('grid').getSelectionModel().clearSelections();
                        btn.up('grid').down('#procesarButton').setDisabled(true);
    					btn.up('grid').down('#downloadButton').setDisabled(true);
				     	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				     },
				     failure: function(response, opts) {
				     	me.getView().unmask();
				     	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				     }
			     });
		     }
		 });
    },
    
    onSelectProcesoCargaMasiva: function(view, record) {
    	
    	var me = this,
    	grid = me.lookupReference("listadoCargamasiva"),
    	processButton = grid.down('#procesarButton'),
    	downloadButton = grid.down('#downloadButton'),
    	validarButton = grid.down('#validarButton');
    	resultadoButton = grid.down('#resultadoButton');
    	
    	validarButton.setDisabled(!record.get("validable"));
    	processButton.setDisabled(!record.get("sePuedeProcesar"));
    	downloadButton.setDisabled(!record.get("conErrores"));
    	resultadoButton.setDisabled(!record.get("conResultados"));
    	
    }
});