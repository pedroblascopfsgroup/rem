Ext.define('HreRem.view.common.WindowExportar', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'windowExportar',
    cls	: 'window-base',
    border: false,
    modal	: true,
	config: null,
	params: null,
	url: null,
	count: 1,
	limiteMax: 1,
	view: null,
	layout: 'fit',
	bodyPadding: 0,
	items: {},
    initComponent: function() {  
    	var me = this;
    	me.items={
    		xtype: 'form',
    		id: 'exportarForm',
    		layout: {
    			type: 'hbox', 
    			pack: 'center', 
    			align: 'center' 
    		},
    		items:[
    			{
    				xtype: 'textfieldbase',
    				id: 'mensajeExportar',
    				name: 'mensajeExportar',
    				reference: 'mensajeExportar',		            				
    				value: parseInt(me.count) < parseInt(me.limiteMax) ? 'Esta usted solicitando una extracci\u00f3n masiva que ser\u00e1 comunicada a Seguridad, Auditor\u00eda y su responsable.' :
    					'Esta usted solicitando una extracci\u00f3n masiva que excede el numero de registros permitidos y su acci\u00f3n ser\u00e1 comunicada a Seguridad, Auditor\u00eda y su responsable.'
    				
    			}
    		],
    		border: false,
    		buttonAlign: 'center',
    		buttons: [
    			  {
    				  text: 'Exportar',
    				  formBind: true,
    				  hidden: !(parseInt(me.count) < parseInt(me.limiteMax)),
    				  handler: function(){
    					  var me = this;
    					  me.up('window').registrarExportacion(true);
    					  		  
    				  }
    			  },
    			  {
    				  text: 'Cancelar', 
    				  handler: function(){	
    					  var me = this;
    					  me.up('window').registrarExportacion(false);
    				  }
    			  }
    		]
    	};
   		me.callParent();
    },
    
    hideWindow: function() {
    	var me = this;    	
    	me.hide();   	
    },
    
    closeWindow: function() {
    	var me = this;
    	me.close();   	
    },
    
    registrarExportacion: function(exportar){
    	var me = this;
    	me.mask(HreRem.i18n("msg.mask.loading"));
    	me.params.exportar = exportar;
    	Ext.Ajax.request({			
		     url: me.url,
		     params: me.params,
		     method: 'POST'
		    ,success: function (a, operation, context) {
		    	me.unmask();
		    	if(exportar)
		    		me.lookupController().fireEvent("downloadFile", me.config);
		    	me.view.unmask();
		    	me.closeWindow();
          },           
          failure: function (a, operation, context) {
          	  Ext.toast({
				     html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACI\u00d3N',
				     width: 360,
				     height: 100,
				     align: 't'
				 });
          	  	me.unmask();
	          	me.view.unmask();
		    	me.closeWindow();
          }
	     
		});
    	    			
    }
    
});