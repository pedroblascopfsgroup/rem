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
                		} else {		                			                	
		                    me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		                    me.getView().lookupReference("listadoCargamasiva").getStore().load();                			
                		}
                	}

                }, 
                failure: function(fp, o) {
                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ok"));                	
                }
            })
    	}
    	
    	
    	
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
    
    
    onClickBotonProcesar: function(btn,b,c) {
debugger;
    	var me = this;
    	var parameters = {};
    	parameters.idProcess = this.getView().down('grid').selection.data.id;
        parameters.idOperation = this.getView().down('grid').selection.data.tipoOperacionId;
    	var url =  $AC.getRemoteUrl('agrupacion/procesarMasivo');
		Ext.Ajax.request({
			 method: 'GET',
		     url: url,
		     params: parameters,
		     timeout: 120000,  // 2 min
		     success: function(response, opts) {
			     Ext.Ajax.request({
			     	 method: 'GET',
				     url:$AC.getRemoteUrl('process/setStateProcessed'),
				     params: parameters,
				     success: function(response, opts) {
				     	btn.up('grid').getStore().load();
				     }
			     });
		     },
		     failure: function(response, opts) {
		         Ext.Ajax.request({
		         	 method: 'GET',
				     url:$AC.getRemoteUrl('process/setStateError'),
				     params: parameters,
				     success: function(response, opts) {
				     	btn.up('grid').getStore().load();
				     }
			     });
		     }
		 });
    }
});